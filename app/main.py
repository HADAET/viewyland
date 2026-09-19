from contextlib import asynccontextmanager
from pathlib import Path

from fastapi import FastAPI
from fastapi.staticfiles import StaticFiles

from app.db.database import initialize_database
from app.routers import admin, auth, cart, checkout, home, products


@asynccontextmanager
async def lifespan(_: FastAPI):
    try:
        initialize_database()
        print("DB connection OK")
    except Exception as e:
        print("DB error:", e)

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

