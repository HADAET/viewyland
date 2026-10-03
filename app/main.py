import threading
import time
from contextlib import asynccontextmanager
from pathlib import Path

from fastapi import FastAPI
from fastapi.staticfiles import StaticFiles

from app.db.database import initialize_database
from app.routers import admin, auth, cart, checkout, home, products
from app.services.product_service import (
    get_active_flash_products,
    get_categories,
    refresh_product_cache,
)


def _warm_cache():
    refresh_product_cache()
    get_active_flash_products()
    get_categories()


def _cache_refresher():
    """Keeps the product cache fresh (and Neon awake) so users never wait."""
    while True:
        #time.sleep(45)  # must be less than PRODUCT_CACHE_TTL (60)
        time.sleep(3600)  
        try:
            _warm_cache()
        except Exception as e:
            print("Cache refresh error:", e)


@asynccontextmanager
async def lifespan(_: FastAPI):
    try:
        initialize_database()
        _warm_cache()
        print("DB connection OK, cache warm")
    except Exception as e:
        print("DB error:", e)

    threading.Thread(target=_cache_refresher, daemon=True).start()

    yield


# /home/hadaet/viewyland/app
BASE_DIR = Path(__file__).resolve().parent

# /home/hadaet/viewyland/app/static
STATIC_DIR = BASE_DIR / "static"

# /home/hadaet/viewyland/app/templates
TEMPLATES_DIR = BASE_DIR / "templates"


app = FastAPI(
    title="Viewyland",
    lifespan=lifespan,
)


# Serve static files using an absolute path
app.mount(
    "/static",
    StaticFiles(directory=STATIC_DIR),
    name="static",
)


app.include_router(home.router)
app.include_router(products.router)
app.include_router(cart.router)
app.include_router(auth.router)
app.include_router(admin.router)
app.include_router(checkout.router)


@app.get("/ping")
def ping():
    return {"status": "ok"}


@app.get("/test-speed")
async def test_speed():
    return {"ok": True}