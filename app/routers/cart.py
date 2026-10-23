from pathlib import Path
from typing import Literal

from fastapi import APIRouter, HTTPException, Request
from fastapi.responses import JSONResponse
from fastapi.templating import Jinja2Templates
from pydantic import BaseModel, Field

from app.services.cart_service import COOKIE_NAME, add_to_cart, cart_count, cart_lines, update_cart
from app.routers.auth import AUTH_COOKIE
from app.services.order_service import DELIVERY_CHARGES, OrderError, confirm_order, create_order, get_customer_by_registration,get_customer_by_mobile, register_customer
from app.services.product_service import get_product, get_recommended_products

router = APIRouter(prefix="/cart", tags=["cart"])
BASE_DIR = Path(__file__).resolve().parent.parent
templates = Jinja2Templates(directory=BASE_DIR / "templates")


class CartItemPayload(BaseModel):
	item_no: str = Field(min_length=1, max_length=16)
	quantity: int | None = Field(default=None, ge=0, le=99)


class AddCartItemPayload(BaseModel):
	item_no: str = Field(min_length=1, max_length=16)
	quantity: int = Field(default=1, ge=1, le=99)


class ConfirmCartPayload(BaseModel):
	customer_name: str = Field(min_length=2, max_length=50)
	mobile_no: str = Field(min_length=7, max_length=25)
	address: str | None = Field(default=None, max_length=200)
	delivery_area: Literal["inside_chittagong", "outside_chittagong"]
	buy_now_item_no: str | None = Field(default=None, min_length=1, max_length=16)
	buy_now_quantity: int = Field(default=1, ge=1, le=99)


@router.get("", name="cart")
async def cart_page(request: Request, buy_now: str | None = None, quantity: int = 1):
	buy_now_product = get_product(buy_now) if buy_now else None
	if buy_now and not buy_now_product:
		raise HTTPException(status_code=404, detail="Product not found")
	quantity = min(max(quantity, 1), 99)
	lines = (
		[{"product": buy_now_product, "quantity": quantity, "total": buy_now_product["price"] * quantity}]
		if buy_now_product
		else cart_lines(request.cookies.get(COOKIE_NAME))
	)
	total = sum(line["total"] for line in lines)
	customer = get_customer_by_registration(request.cookies.get(AUTH_COOKIE, "")) if request.cookies.get(AUTH_COOKIE) else None
	return templates.TemplateResponse(
		request=request,
		name="cart.html",
		context={
			"lines": lines,
			"total": total,
			"customer": customer,
			"cart_count": cart_count(request.cookies.get(COOKIE_NAME)),
			"delivery_charges": DELIVERY_CHARGES,
			"buy_now_item_no": buy_now_product["id"] if buy_now_product else None,
			"recommended_products": get_recommended_products(
				[line["product"]["category"] for line in lines],
				exclude_ids={line["product"]["id"] for line in lines},
			) if lines else [],
		},
	)


@router.post("/items")
async def add_item(request: Request, payload: AddCartItemPayload):
	try:
		cookie, count = add_to_cart(request.cookies.get(COOKIE_NAME), payload.item_no, payload.quantity)
	except ValueError as error:
		raise HTTPException(status_code=404, detail=str(error)) from error
	response = JSONResponse({"ok": True, "cart_count": count})
	response.set_cookie(COOKIE_NAME, cookie, max_age=60 * 60 * 24 * 30, httponly=True, samesite="lax")
	return response


@router.patch("/items")
async def change_item(request: Request, payload: CartItemPayload):
	try:
		cookie, count = update_cart(request.cookies.get(COOKIE_NAME), payload.item_no, payload.quantity or 0)
	except ValueError as error:
		raise HTTPException(status_code=404, detail=str(error)) from error
	response = JSONResponse({"ok": True, "cart_count": count})
	response.set_cookie(COOKIE_NAME, cookie, max_age=60 * 60 * 24 * 30, httponly=True, samesite="lax")
	return response


#@router.post("/confirm")
#async def confirm_cart(request: Request, payload: ConfirmCartPayload):
#	lines = cart_lines(request.cookies.get(COOKIE_NAME))
#	if not lines:
#		raise HTTPException(status_code=400, detail="Your cart is empty.")
#	try:
#		customer = get_customer_by_registration(request.cookies.get(AUTH_COOKIE, "")) if request.cookies.get(AUTH_COOKIE) else None
#		if not customer:
#			register_customer(payload.customer_name, payload.mobile_no, None, payload.address)
#		order = create_order(payload.mobile_no, "VL-MAIN", [{"item_no": line["product"]["id"], "quantity": line["quantity"], "discount_amount": 0} for line in lines], payload.address)
#		confirmed = confirm_order(order["order_no"], "COD", order["payable_amount"])
#	except OrderError as error:
#		raise HTTPException(status_code=400, detail=str(error)) from error
#	#response = JSONResponse({"ok": True, "order_no": confirmed["order_no"], "payable_amount": confirmed["payable_amount"]})
#	response = JSONResponse({
#    "ok": True,
#    "order_no": confirmed["order"]["order_no"],
#    "payable_amount": confirmed["order"]["payable_amount"],})
#	response.delete_cookie(COOKIE_NAME)
#	return response

@router.post("/confirm")
async def confirm_cart(request: Request, payload: ConfirmCartPayload):
	lines = (
		[{"product": get_product(payload.buy_now_item_no), "quantity": payload.buy_now_quantity}]
		if payload.buy_now_item_no
		else cart_lines(request.cookies.get(COOKIE_NAME))
	)
	if payload.buy_now_item_no and not lines[0]["product"]:
		raise HTTPException(status_code=404, detail="Product not found")
	if not lines:
		raise HTTPException(status_code=400, detail="Your cart is empty.")

	auto_login_registration_no = None
	try:
		customer = get_customer_by_registration(request.cookies.get(AUTH_COOKIE, "")) if request.cookies.get(AUTH_COOKIE) else None

		if not customer:
			existing_customer = get_customer_by_mobile(payload.mobile_no)
			if existing_customer:
				# Mobile no already registered কিন্তু login করা নাই -> auto sign-in
				customer = existing_customer
				auto_login_registration_no = existing_customer["registration_no"]
			else:
				registration_no, _ = register_customer(payload.customer_name, payload.mobile_no, None, payload.address)
				auto_login_registration_no = registration_no

		order = create_order(
			payload.mobile_no,
			"VL-MAIN",
			[{"item_no": line["product"]["id"], "quantity": line["quantity"], "discount_amount": 0} for line in lines],
			payload.delivery_area,
			payload.address,
		)
		confirmed = confirm_order(order["order_no"], "COD", order["payable_amount"])
	except OrderError as error:
		raise HTTPException(status_code=400, detail=str(error)) from error

	response = JSONResponse({
		"ok": True,
		"order_no": confirmed["order"]["order_no"],
		"payable_amount": confirmed["order"]["payable_amount"],
	})
	if not payload.buy_now_item_no:
		response.delete_cookie(COOKIE_NAME)

	if auto_login_registration_no:
		response.set_cookie(
			AUTH_COOKIE,
			auto_login_registration_no,
			max_age=60 * 60 * 24 * 30,
			httponly=True,
			samesite="lax",
		)

	return response
