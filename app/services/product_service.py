import time
from threading import Lock

from app.db.database import get_connection
from app.db.queries import PRODUCT_SELECT


CATEGORY_DETAILS = {
    "Vintage clocks": ("Timepieces with a story to tell.", "clock"),
    "Showpiece decor": ("Objects made to start a conversation.", "vase"),
    "Table lamps": ("A warmer kind of illumination.", "lamp"),
    "Wall & mirrors": ("Details that complete the room.", "mirror"),
}

CATEGORY_ICONS = ["clock", "lamp", "mirror", "vase"]


# =========================================================
# SIMPLE IN-MEMORY CACHE
# =========================================================
# Every page used to hit the (remote Neon) database several times.
# Now the data is loaded once and reused for CACHE_TTL seconds.
# Call clear_product_cache() after any admin change to products,
# prices, images or flash sales so the site shows fresh data.
# NOTE: cached objects are shared - callers must not mutate them.

PRODUCT_CACHE_TTL = 60   # seconds
FLASH_CACHE_TTL = 30     # seconds
CATEGORY_CACHE_TTL = 60  # seconds

_cache_lock = Lock()
_products_cache = {"t": 0.0, "data": None}
_flash_cache = {"t": 0.0, "data": None}
_categories_cache = {"t": 0.0, "data": None}


def _is_fresh(entry: dict, ttl: int) -> bool:
    return entry["data"] is not None and (time.time() - entry["t"]) < ttl


def clear_product_cache():
    """Call this after admin adds/edits/deletes products, prices, images or flash sales."""
    with _cache_lock:
        for entry in (_products_cache, _flash_cache, _categories_cache):
            entry["data"] = None
            entry["t"] = 0.0


# =========================================================
# CATEGORIES
# =========================================================

def _load_categories():
    with get_connection() as connection:
        rows = connection.execute(
            """SELECT DISTINCT item_category
               FROM bus_item_master
               WHERE active_status = 'Y'
               ORDER BY item_category"""
        ).fetchall()

    categories = []
    for index, row in enumerate(rows):
        name = row["item_category"]
        description = CATEGORY_DETAILS.get(name, ("Curated pieces for your home.", ""))[0]
        categories.append({
            "name": name,
            "description": description,
            "icon": CATEGORY_ICONS[index % len(CATEGORY_ICONS)],
        })
    return categories


def get_categories():
    if _is_fresh(_categories_cache, CATEGORY_CACHE_TTL):
        return _categories_cache["data"]
    with _cache_lock:
        if not _is_fresh(_categories_cache, CATEGORY_CACHE_TTL):
            _categories_cache["data"] = _load_categories()
            _categories_cache["t"] = time.time()
        return _categories_cache["data"]


# =========================================================
# PRODUCTS
# =========================================================

def _load_products():
    """Load ALL active products (with images) from the database. 2 queries total."""
    query = PRODUCT_SELECT + " ORDER BY item.item_no"

    with get_connection() as connection:
        rows = connection.execute(query).fetchall()
        ids = [row["item_no"] for row in rows]
        image_rows = connection.execute(
            "SELECT item_no, image_url, alt_text FROM item_image "
            "WHERE active_status = 'Y' AND item_no = ANY(?) "
            "ORDER BY item_no, display_order, image_id",
            (ids,),
        ).fetchall() if ids else []

    images_by_item: dict[str, list[dict]] = {}
    for image in image_rows:
        images_by_item.setdefault(image["item_no"], []).append(
            {"url": image["image_url"], "alt": image["alt_text"] or ""}
        )

    return [
        {
            "id": row["item_no"],
            "name": row["item_name"],
            "description": row["item_description"],
            "category": row["item_category"],
            "price": row["rate"],
            "tag": row["product_tag"] or "",
            "tone": row["display_tone"],
            "type": row["display_type"],
            "previous_price": row["previous_price"],
            "currency": row["currency"] or "TK.",
            "images": images_by_item.get(row["item_no"], []),
        }
        for row in rows
    ]


def _all_products():
    if _is_fresh(_products_cache, PRODUCT_CACHE_TTL):
        return _products_cache["data"]
    with _cache_lock:
        # re-check: another thread may have refreshed while we waited
        if not _is_fresh(_products_cache, PRODUCT_CACHE_TTL):
            _products_cache["data"] = _load_products()
            _products_cache["t"] = time.time()
        return _products_cache["data"]


def get_products(category: str | None = None, search: str | None = None, limit: int | None = None):
    items = _all_products()

    if category:
        items = [p for p in items if p["category"] == category]
    if search:
        term = search.strip().lower()
        items = [
            p for p in items
            if term in (p["name"] or "").lower() or term in (p["description"] or "").lower()
        ]

    return items[:limit] if limit else items


def get_featured_products():
    return get_products(limit=4)


def get_product(item_no: str):
    item_no = item_no.strip().upper()
    return next((p for p in _all_products() if p["id"] == item_no), None)


# =========================================================
# FLASH SALE
# =========================================================

def _load_flash_products():
    with get_connection() as connection:
        rows = connection.execute(
            """SELECT item_no, sale_price, currency FROM flash_sale
            WHERE active_status = 'Y' AND starts_on::timestamp <= CURRENT_TIMESTAMP AND ends_on::timestamp >= CURRENT_TIMESTAMP
            ORDER BY ends_on"""
        ).fetchall()

    products = {product["id"]: product for product in _all_products()}
    result = []
    for row in rows:
        product = products.get(row["item_no"])
        if product:
            product = dict(product)  # copy, so the cached product keeps its normal price
            product["price"] = row["sale_price"] or product["price"]
            product["currency"] = row["currency"] or product["currency"]
            result.append(product)
    return result


def get_active_flash_products():
    if _is_fresh(_flash_cache, FLASH_CACHE_TTL):
        return _flash_cache["data"]
    with _cache_lock:
        if not _is_fresh(_flash_cache, FLASH_CACHE_TTL):
            _flash_cache["data"] = _load_flash_products()
            _flash_cache["t"] = time.time()
        return _flash_cache["data"]

# to make less logs in neon DB, changing new code
#def refresh_product_cache():
#    """Reload products in the background and swap them in, so users never wait."""
#    products = _load_products()
#    with _cache_lock:
#        _products_cache["data"] = products
#        _products_cache["t"] = time.time()
def refresh_product_cache():
    if _is_fresh(_products_cache, PRODUCT_CACHE_TTL):
        return _products_cache["data"]

    products = _load_products()

    with _cache_lock:
        _products_cache["data"] = products
        _products_cache["t"] = time.time()

    return products
import random


def get_mixed_products(limit: int = 24, per_category: int = 3):
    """Pick up to `per_category` random products from each category,
    shuffled, so the homepage never shows one category back-to-back."""
    items = list(_all_products())
    random.shuffle(items)

    by_category: dict[str, list[dict]] = {}
    for p in items:
        by_category.setdefault(p["category"], []).append(p)

    picked: list[dict] = []
    for products in by_category.values():
        picked.extend(products[:per_category])

    random.shuffle(picked)
    return picked[:limit]        