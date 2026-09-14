from fastapi import APIRouter, Query, Request
from fastapi.templating import Jinja2Templates

from app.services.product_service import get_categories, get_product, get_products
from app.services.cart_service import COOKIE_NAME, cart_count

router = APIRouter(prefix="/products", tags=["products"])
templates = Jinja2Templates(directory="app/templates")


@router.get("", name="products")
async def products_page(
    request: Request,
    category: str | None = Query(default=None),
    q: str | None = Query(default=None),
):
    return templates.TemplateResponse(
        request=request,
        name="products.html",
        context={
            "products": get_products(category=category, search=q),
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
