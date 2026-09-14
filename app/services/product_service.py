from app.db.database import get_connection
from app.db.queries import PRODUCT_SELECT


CATEGORY_DETAILS = {
    "Vintage clocks": ("Timepieces with a story to tell.", "clock"),
    "Showpiece decor": ("Objects made to start a conversation.", "vase"),
    "Table lamps": ("A warmer kind of illumination.", "lamp"),
    "Wall & mirrors": ("Details that complete the room.", "mirror"),
}


def get_categories():
    with get_connection() as connection:
        rows = connection.execute(
            """SELECT DISTINCT item_category FROM bus_item_master
            WHERE active_status = 'Y' ORDER BY item_category"""
        ).fetchall()

    return [
        {"name": row["item_category"], "description": CATEGORY_DETAILS.get(row["item_category"], ("Curated pieces for your home.", "vase"))[0], "icon": CATEGORY_DETAILS.get(row["item_category"], ("", "vase"))[1]}
        for row in rows
    ]


def get_featured_products():
    return get_products(limit=4)


def get_products(category: str | None = None, search: str | None = None, limit: int | None = None):
    query = PRODUCT_SELECT
    params: list[object] = []

    if category:
        query += " AND item.item_category = ?"
        params.append(category)
    if search:
        query += " AND (item.item_name LIKE ? OR item.item_description LIKE ?)"
        term = f"%{search.strip()}%"
        params.extend([term, term])

    query += " ORDER BY item.item_no"
    if limit:
        query += " LIMIT ?"
        params.append(limit)

    with get_connection() as connection:
        rows = connection.execute(query, params).fetchall()
        image_rows = connection.execute(
            "SELECT item_no, image_url, alt_text FROM item_image WHERE active_status = 'Y' ORDER BY item_no, display_order, image_id"
        ).fetchall()
    images_by_item: dict[str, list[dict]] = {}
    for image in image_rows:
        images_by_item.setdefault(image["item_no"], []).append({"url": image["image_url"], "alt": image["alt_text"] or ""})

    return [
        {
            "id": row["item_no"], "name": row["item_name"], "description": row["item_description"],
            "category": row["item_category"], "price": row["rate"], "tag": row["product_tag"] or "",
            "tone": row["display_tone"], "type": row["display_type"], "previous_price": row["previous_price"],
            "currency": row["currency"] or "TK.", "images": images_by_item.get(row["item_no"], []),
        }
        for row in rows
    ]


def get_product(item_no: str):
    return next((product for product in get_products() if product["id"] == item_no.upper()), None)


def get_active_flash_products():
    with get_connection() as connection:
        rows = connection.execute(
            """SELECT item_no, sale_price, currency FROM flash_sale
            WHERE active_status = 'Y' AND starts_on <= CURRENT_TIMESTAMP AND ends_on >= CURRENT_TIMESTAMP
            ORDER BY ends_on"""
        ).fetchall()
    products = {product["id"]: product for product in get_products()}
    result = []
    for row in rows:
        product = products.get(row["item_no"])
        if product:
            product = dict(product)
            product["price"] = row["sale_price"] or product["price"]
            product["currency"] = row["currency"] or product["currency"]
            result.append(product)
    return result
