from contextlib import asynccontextmanager
from pathlib import Path

from fastapi import FastAPI
from fastapi.staticfiles import StaticFiles

from app.db.database import initialize_database
from app.routers import admin, auth, cart, checkout, home, products


@asynccontextmanager
async def lifespan(_: FastAPI):
    initialize_database()
    yield


BASE_DIR = Path(__file__).resolve().parent

app = FastAPI(title="Viewyland", lifespan=lifespan)
app.mount("/static", StaticFiles(directory=BASE_DIR / "static"), name="static")

app.include_router(home.router)
app.include_router(products.router)
app.include_router(cart.router)
app.include_router(auth.router)
app.include_router(admin.router)
app.include_router(checkout.router)
