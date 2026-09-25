from pathlib import Path
from fastapi import APIRouter, HTTPException, Request
from fastapi.responses import JSONResponse
from fastapi.templating import Jinja2Templates
from pydantic import BaseModel, Field

from app.services.cart_service import COOKIE_NAME, add_to_cart, cart_count, cart_lines, update_cart
from app.routers.auth import AUTH_COOKIE
from app.services.order_service import OrderError, confirm_order, create_order, get_customer_by_registration,get_customer_by_mobile, register_customer

router = APIRouter(prefix="/cart", tags=["cart"])
BASE_DIR = Path(__file__).resolve().parent.parent
templates = Jinja2Templates(directory=BASE_DIR / "templates")


class CartItemPayload(BaseModel):
	item_no: str = Field(min_length=1, max_length=16)
	quantity: int | None = Field(default=None, ge=0, le=99)


class ConfirmCartPayload(BaseModel):
	customer_name: str = Field(min_length=2, max_length=50)
	mobile_no: str = Field(min_length=7, max_length=25)
	address: str | None = Field(default=None, max_length=200)


@router.get("", name="cart")
async def cart_page(request: Request):
	lines = cart_lines(request.cookies.get(COOKIE_NAME))
	total = sum(line["total"] for line in lines)
	customer = get_customer_by_registration(request.cookies.get(AUTH_COOKIE, "")) if request.cookies.get(AUTH_COOKIE) else None
	return templates.TemplateResponse(request=request, name="cart.html", context={"lines": lines, "total": total, "customer": customer, "cart_count": cart_count(request.cookies.get(COOKIE_NAME))})


@router.post("/items")
async def add_item(request: Request, payload: CartItemPayload):
	try:
		cookie, count = add_to_cart(request.cookies.get(COOKIE_NAME), payload.item_no)
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
	lines = cart_lines(request.cookies.get(COOKIE_NAME))
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