from pathlib import Path
from fastapi import APIRouter, Request
from fastapi.templating import Jinja2Templates

from app.services.product_service import get_active_flash_products, get_categories, get_featured_products, get_mixed_products, get_products
from app.services.cart_service import COOKIE_NAME, cart_count
from app.routers.auth import AUTH_COOKIE
from app.services.order_service import get_customer_by_registration

router = APIRouter()
#templates = Jinja2Templates(directory="app/templates")
BASE_DIR = Path(__file__).resolve().parent.parent
templates = Jinja2Templates(directory=BASE_DIR / "templates")

BANNERS = [
    {
        "eyebrow": "New season, new mood",
        "title": "Small pieces. Big character.",
        "copy": "Refresh a room with one considered object at a time.",
        "tone": "sage",
        "images": [
        "https://bd-live-21.slatic.net/kf/S3ac9cf6c7c534db58950c783c508794c2.jpg",
        "https://static-01.daraz.com.bd/p/48e5edfafd1d4dc713d2dbc2a1644e8d.jpg",
        "https://static-01.daraz.com.bd/p/a77ba4cede76ed99a4a3ba4ed2d3fdf0.jpg",
        ],
    },
    {
        "eyebrow": "New season, new mood",
        "title": "Small pieces. Big character.",
        "copy": "Refresh a room with one considered object at a time.",
        "tone": "sage",
        "images": [
        "https://static-01.daraz.com.bd/p/a48064cb2df5a1b72366e84e44bae3b2.jpg",
        "https://static-01.daraz.com.bd/p/0bfc3a3d453aa3a248e4b6f1cb95508f.jpg",
        "https://bd-live-21.slatic.net/kf/Sbb66ac500c194abda974b4fab9de65a5b.jpg",
        ],
    },
    {
        "eyebrow": "New season, new mood",
        "title": "Small pieces. Big character.",
        "copy": "Refresh a room with one considered object at a time.",
        "tone": "sage",
        "images": [
        "https://static-01.daraz.com.bd/p/99e5d96159f3a7b99b7151072a3e3555.jpg",
        "https://static-01.daraz.com.bd/p/ce1645b7071291f2e38887246d776b37.jpg",
        "https://bd-live-21.slatic.net/kf/S7615f907368d467ab033c2760f5e5c5ae.jpg",
        ],
    },
    {
        "eyebrow": "New season, new mood",
        "title": "Small pieces. Big character.",
        "copy": "Refresh a room with one considered object at a time.",
        "tone": "sage",
        "images": [
        "https://bd-live-21.slatic.net/kf/S4630288cf56d45ef8067be2056c159c2h.jpg",
        "https://static-01.daraz.com.bd/p/4063dd195f6e27ea9fa0acf97c175da0.jpg",
        "https://bd-live-21.slatic.net/kf/S075f7618f00048e68daa9d8b0ba249c4q.jpg",
        ],
    },
    {
        "eyebrow": "New season, new mood",
        "title": "Small pieces. Big character.",
        "copy": "Refresh a room with one considered object at a time.",
        "tone": "sage",
        "images": [
        "https://static-01.daraz.com.bd/p/fc20e74216fe85dbd5d6a665af84d95a.jpg",
        "https://static-01.daraz.com.bd/p/2658410741c3d0f3bc0c7876d3501fe4.jpg",
        "https://static-01.daraz.com.bd/p/4688b2921561f0c5040cf13c55a34335.jpg",
        ],
    },
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
            "market_products": get_mixed_products(limit=24, per_category=2),
            "flash_products": get_active_flash_products(),
            "categories": get_categories(),
            "cart_count": cart_count(request.cookies.get(COOKIE_NAME)),
            "hide_global_nav": True,
            "customer": customer,
            "banners": BANNERS,
        },
    )