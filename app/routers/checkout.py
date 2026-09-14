from fastapi import APIRouter, HTTPException
from pydantic import BaseModel, Field

from app.services.order_service import OrderError, confirm_order, create_order, get_order, register_customer

router = APIRouter(prefix="/checkout", tags=["checkout"])


class RegistrationPayload(BaseModel):
    customer_name: str = Field(min_length=2, max_length=50)
    mobile_no: str = Field(min_length=7, max_length=25)
    email: str | None = Field(default=None, max_length=100)
    address: str | None = Field(default=None, max_length=200)


class OrderLinePayload(BaseModel):
    item_no: str = Field(min_length=1, max_length=16)
    quantity: int = Field(gt=0, le=99)
    discount_amount: float = Field(default=0, ge=0)


class OrderPayload(BaseModel):
    mobile_no: str = Field(min_length=7, max_length=25)
    store_no: str = "VL-MAIN"
    delivery_address: str | None = Field(default=None, max_length=200)
    lines: list[OrderLinePayload] = Field(min_length=1)


class ConfirmationPayload(BaseModel):
    payment_type: str = Field(default="ONLINE", min_length=2, max_length=30)
    paid_amount: float = Field(gt=0)


def fail(error: OrderError):
    raise HTTPException(status_code=400, detail=str(error)) from error


@router.post("/register", status_code=201)
async def register(payload: RegistrationPayload):
    try:
        registration_no, created = register_customer(**payload.model_dump())
    except OrderError as error:
        fail(error)
    return {"registration_no": registration_no, "created": created}


@router.post("/orders", status_code=201)
async def place_order(payload: OrderPayload):
    try:
        return create_order(payload.mobile_no, payload.store_no, [line.model_dump() for line in payload.lines], payload.delivery_address)
    except OrderError as error:
        fail(error)


@router.get("/orders/{order_no}")
async def read_order(order_no: str):
    try:
        return get_order(order_no)
    except OrderError as error:
        fail(error)


@router.post("/orders/{order_no}/confirm")
async def confirm(order_no: str, payload: ConfirmationPayload):
    try:
        return confirm_order(order_no, payload.payment_type, payload.paid_amount)
    except OrderError as error:
        fail(error)
