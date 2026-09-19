from pathlib import Path
from pathlib import Path
from uuid import uuid4

from fastapi import APIRouter, File, HTTPException, Request, UploadFile
from fastapi.responses import JSONResponse
from fastapi.templating import Jinja2Templates
from pydantic import BaseModel, Field

from app.db.database import get_connection
from app.services.order_service import OrderError, get_customer_by_mobile, get_customer_by_registration, register_customer

router = APIRouter(prefix="/auth", tags=["auth"])
BASE_DIR = Path(__file__).resolve().parent.parent
templates = Jinja2Templates(directory=BASE_DIR / "templates")
AUTH_COOKIE = "viewyland_customer"
PROFILE_UPLOAD_DIR = Path("app/static/uploads/profiles")
ALLOWED_IMAGE_TYPES = {"image/jpeg": ".jpg", "image/png": ".png", "image/webp": ".webp"}


class RegisterPayload(BaseModel):
    customer_name: str = Field(min_length=2, max_length=50)
    mobile_no: str = Field(min_length=7, max_length=25)
    address: str | None = Field(default=None, max_length=200)


class LoginPayload(BaseModel):
    mobile_no: str = Field(min_length=7, max_length=25)


class ProfilePayload(BaseModel):
    customer_name: str = Field(min_length=2, max_length=50)
    mobile_no: str = Field(min_length=7, max_length=25)
    email: str | None = Field(default=None, max_length=100)
    address: str | None = Field(default=None, max_length=200)
    profile_image: str | None = Field(default=None, max_length=500)


@router.get("", name="auth")
async def auth_page(request: Request):
    customer = get_customer_by_registration(request.cookies.get(AUTH_COOKIE, "")) if request.cookies.get(AUTH_COOKIE) else None
    orders = []
    if customer:
        with get_connection() as connection:
            orders = [dict(row) for row in connection.execute("SELECT order_no, order_status, payment_status, payable_amount, created_on FROM order_master WHERE registration_no=? ORDER BY created_on DESC", (customer["registration_no"],)).fetchall()]
            order_lines = connection.execute(
                """SELECT detail.order_no, detail.item_no, detail.item_name_snapshot, detail.quantity, detail.unit_price, detail.line_total,
                item.display_tone, item.display_type, image.image_url
                FROM order_details AS detail
                LEFT JOIN bus_item_master AS item ON item.item_no = detail.item_no
                LEFT JOIN item_image AS image ON image.image_id = (
                    SELECT image_id FROM item_image
                    WHERE item_no = detail.item_no AND active_status = 'Y'
                    ORDER BY display_order, image_id LIMIT 1
                )
                WHERE detail.order_no IN (SELECT order_no FROM order_master WHERE registration_no=?)
                ORDER BY detail.order_line_no""",
                (customer["registration_no"],),
            ).fetchall()
        lines_by_order: dict[str, list[dict]] = {}
        for line in order_lines:
            lines_by_order.setdefault(line["order_no"], []).append(dict(line))
        for order in orders:
            order["lines"] = lines_by_order.get(order["order_no"], [])
    return templates.TemplateResponse(request=request, name="auth.html", context={"customer": customer, "orders": orders, "cart_count": 0})


@router.post("/register", status_code=201)
async def register(payload: RegisterPayload):
    try:
        registration_no, _ = register_customer(payload.customer_name, payload.mobile_no, None, payload.address)
    except OrderError as error:
        raise HTTPException(status_code=409, detail=str(error)) from error
    response = JSONResponse({"ok": True, "registration_no": registration_no, "message": "Registration successful."})
    response.set_cookie(AUTH_COOKIE, registration_no, max_age=60 * 60 * 24 * 30, httponly=True, samesite="lax")
    return response


@router.post("/login")
async def login(payload: LoginPayload):
    customer = get_customer_by_mobile(payload.mobile_no)
    if not customer:
        raise HTTPException(status_code=401, detail="Mobile number is not registered.")
    response = JSONResponse({"ok": True, "customer_name": customer["customer_name"], "message": "Login successful."})
    response.set_cookie(AUTH_COOKIE, customer["registration_no"], max_age=60 * 60 * 24 * 30, httponly=True, samesite="lax")
    return response


@router.post("/logout")
async def logout():
    response = JSONResponse({"ok": True})
    response.delete_cookie(AUTH_COOKIE)
    return response


@router.patch("/profile")
async def update_profile(request: Request, payload: ProfilePayload):
    customer = get_customer_by_registration(request.cookies.get(AUTH_COOKIE, "")) if request.cookies.get(AUTH_COOKIE) else None
    if not customer:
        raise HTTPException(status_code=401, detail="Please log in to update your profile.")
    with get_connection() as connection:
        existing_customer = connection.execute("SELECT registration_no FROM bus_registration WHERE mobile_no=? AND registration_no<>?", (payload.mobile_no.strip(), customer["registration_no"])).fetchone()
        if existing_customer:
            raise HTTPException(status_code=409, detail="This mobile number is already registered.")
        connection.execute("UPDATE bus_registration SET customer_name=?, mobile_no=?, email=?, present_address=?, profile_image=?, updated_on=CURRENT_TIMESTAMP WHERE registration_no=?", (payload.customer_name.strip(), payload.mobile_no.strip(), payload.email, payload.address, payload.profile_image, customer["registration_no"]))
    return {"ok": True, "message": "Profile updated successfully."}


@router.post("/profile-image")
async def upload_profile_image(request: Request, image: UploadFile = File(...)):
    customer = get_customer_by_registration(request.cookies.get(AUTH_COOKIE, "")) if request.cookies.get(AUTH_COOKIE) else None
    if not customer:
        raise HTTPException(status_code=401, detail="Please log in to update your profile image.")
    extension = ALLOWED_IMAGE_TYPES.get(image.content_type or "")
    if not extension:
        raise HTTPException(status_code=400, detail="Use a JPG, PNG, or WebP image.")
    content = await image.read()
    if len(content) > 5 * 1024 * 1024:
        raise HTTPException(status_code=400, detail="Profile image must be 5 MB or smaller.")
    PROFILE_UPLOAD_DIR.mkdir(parents=True, exist_ok=True)
    filename = f"{customer['registration_no']}-{uuid4().hex}{extension}"
    (PROFILE_UPLOAD_DIR / filename).write_bytes(content)
    image_path = f"/static/uploads/profiles/{filename}"
    with get_connection() as connection:
        connection.execute("UPDATE bus_registration SET profile_image=?, updated_on=CURRENT_TIMESTAMP WHERE registration_no=?", (image_path, customer["registration_no"]))
    return {"ok": True, "profile_image": image_path, "message": "Profile image updated."}


