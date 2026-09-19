from pathlib import Path
from fastapi import APIRouter, Request
from fastapi.templating import Jinja2Templates

from app.services.product_service import get_active_flash_products, get_categories, get_featured_products, get_products
from app.services.cart_service import COOKIE_NAME, cart_count
from app.routers.auth import AUTH_COOKIE
from app.services.order_service import get_customer_by_registration

router = APIRouter()
#templates = Jinja2Templates(directory="app/templates")
BASE_DIR = Path(__file__).resolve().parent.parent
templates = Jinja2Templates(directory=BASE_DIR / "templates")

BANNERS = [
    {"eyebrow": "The Viewyland home edit", "title": "Make space for something beautiful.", "copy": "Collected objects, everyday essentials and special finds for your home.", "tone": "peach"},
    {"eyebrow": "New season, new mood", "title": "Small pieces. Big character.", "copy": "Refresh a room with one considered object at a time.", "tone": "sage"},
    {"eyebrow": "Viewyland weekend offer", "title": "Find your next treasure.", "copy": "Handpicked showpieces, ready to make your space feel like yours.", "tone": "gold"},
]


@router.get("/", name="home")
async def home_page(request: Request):
    customer = get_customer_by_registration(request.cookies.get(AUTH_COOKIE, "")) if request.cookies.get(AUTH_COOKIE) else None
    return templates.TemplateResponse(
        request=request,
        name="home.html",
        context={
            "featured_products": get_featured_products(),
            "hero_products": get_products(limit=4),
            "market_products": get_products(limit=8),
            "flash_products": get_active_flash_products(),
            "categories": get_categories(),
            "cart_count": cart_count(request.cookies.get(COOKIE_NAME)),
            "hide_global_nav": True,
            "customer": customer,
            "banners": BANNERS,
        },
    )
