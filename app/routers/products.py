from pathlib import Path
from fastapi import APIRouter, Query, Request
from fastapi.templating import Jinja2Templates

from app.services.product_service import get_categories, get_product, get_products
from app.services.cart_service import COOKIE_NAME, cart_count
from app.services.product_service import get_categories, get_product, get_products_page

PER_PAGE = 15
router = APIRouter(prefix="/products", tags=["products"])
BASE_DIR = Path(__file__).resolve().parent.parent
templates = Jinja2Templates(directory=BASE_DIR / "templates")


@router.get("", name="products")
async def products_page(
    request: Request,
    category: str | None = Query(default=None),
    q: str | None = Query(default=None),
    page: int = Query(default=1, ge=1),
):
    products, total, page, total_pages = get_products_page(
        page=page, per_page=PER_PAGE, category=category, search=q
    )
    return templates.TemplateResponse(
        request=request,
        name="products.html",
        context={
            "products": products,
            "total": total,
            "page": page,
            "total_pages": total_pages,
            "categories": get_categories(),
            "selected_category": category,
            "search_query": q or "",
            "cart_count": cart_count(request.cookies.get(COOKIE_NAME)),
        },
    )

@router.get("/{item_no}", name="product_detail")
async def product_detail_page(request: Request, item_no: str):
    product = get_product(item_no)
    if not product:
        from fastapi import HTTPException
        raise HTTPException(status_code=404, detail="Product not found")
    return templates.TemplateResponse(request=request, name="product_detail.html", context={"product": product, "cart_count": cart_count(request.cookies.get(COOKIE_NAME))})
