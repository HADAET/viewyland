import hashlib
import hmac
import os
import re
import sqlite3
from datetime import datetime
from pathlib import Path
from uuid import uuid4

from fastapi import APIRouter, Form, HTTPException, Request, UploadFile
from fastapi.responses import RedirectResponse
from fastapi.templating import Jinja2Templates

from app.db.database import get_connection
router = APIRouter(prefix="/admin", tags=["admin"])
templates = Jinja2Templates(directory="app/templates")
ADMIN_COOKIE = "viewyland_admin"
ADMIN_PASSWORD = os.getenv("VIEWYLAND_ADMIN_PASSWORD", "change-me")
ITEM_IMAGE_UPLOAD_DIR = Path("app/static/uploads/items")
ALLOWED_IMAGE_TYPES = {"image/jpeg": ".jpg", "image/png": ".png", "image/webp": ".webp"}
DATETIME_LOCAL_PATTERN = re.compile(r"^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}$")
AUTO_ID_PREFIXES = {
    "bus_registration": "CUS",
    "wms_store_mst": "ST",
    "order_master": "ORD",
    "wms_sh_invheader": "INV",
    "wms_sh_payment": "MR",
}
TABLES = [
    "bus_item_master", "bus_item_category", "bus_price_list", "bus_registration", "flash_sale", "item_image",
    "order_details", "order_master", "products", "wms_item_stock", "wms_sh_invheader",
    "wms_sh_invline", "wms_sh_payment", "wms_store_mst",
]
READ_ONLY_TABLES = {"products"}


def _admin_token() -> str:
    return hashlib.sha256(ADMIN_PASSWORD.encode()).hexdigest()


def is_admin(request: Request) -> bool:
    return hmac.compare_digest(request.cookies.get(ADMIN_COOKIE, ""), _admin_token())


def require_admin(request: Request):
    if not is_admin(request):
        raise HTTPException(status_code=401, detail="Admin login required")


def validate_table(table_name: str) -> str:
    if table_name not in TABLES:
        raise HTTPException(status_code=404, detail="Unknown table")
    return table_name


def table_columns(connection: sqlite3.Connection, table_name: str) -> list[dict]:
    if table_name == "products":
        return [
            {"name": "item_no", "type": "TEXT", "notnull": 1, "pk": 1, "auto_id": False, "is_date": False},
            {"name": "item_name", "type": "TEXT", "notnull": 1, "pk": 0, "auto_id": False, "is_date": False},
            {"name": "item_category", "type": "TEXT", "notnull": 1, "pk": 0, "auto_id": False, "is_date": False},
            {"name": "rate", "type": "REAL", "notnull": 1, "pk": 0, "auto_id": False, "is_date": False},
            {"name": "currency", "type": "TEXT", "notnull": 1, "pk": 0, "auto_id": False, "is_date": False},
            {"name": "active_status", "type": "TEXT", "notnull": 1, "pk": 0, "auto_id": False, "is_date": False},
        ]
    columns = [dict(row) for row in connection.execute(f"PRAGMA table_info({table_name})").fetchall()]
    pk_columns = [column for column in columns if column["pk"]]
    # Only a single TEXT primary key is treated as an auto-generated identity; composite keys are foreign-key pickers.
    auto_id_name = pk_columns[0]["name"] if len(pk_columns) == 1 and pk_columns[0]["type"].upper() == "TEXT" else None
    for column in columns:
        column["auto_id"] = column["name"] == auto_id_name
        column["is_date"] = column["name"].endswith(("_on", "_date"))
    return columns


def generate_auto_id(connection: sqlite3.Connection, table_name: str, column_name: str) -> str:
    if table_name == "bus_item_master":
        next_number = 1
        for (item_no,) in connection.execute("SELECT item_no FROM bus_item_master WHERE item_no LIKE 'VL-%'").fetchall():
            suffix = item_no.rsplit("-", 1)[-1]
            if suffix.isdigit():
                next_number = max(next_number, int(suffix) + 1)
        return f"VL-{next_number:03d}"
    prefix = AUTO_ID_PREFIXES.get(table_name, table_name[:3].upper())
    return f"{prefix}-{datetime.now():%Y%m%d}-{uuid4().hex[:8].upper()}"


def normalize_datetime_value(value: str) -> str:
    if DATETIME_LOCAL_PATTERN.match(value):
        return value.replace("T", " ") + ":00"
    return value


def item_options(connection: sqlite3.Connection) -> list[dict]:
    return [dict(row) for row in connection.execute("SELECT item_no, item_name FROM bus_item_master ORDER BY item_name").fetchall()]


def category_options(connection: sqlite3.Connection) -> list[str]:
    return [row[0] for row in connection.execute("SELECT category_name FROM bus_item_category WHERE active_status='Y' ORDER BY category_name").fetchall()]


def store_options(connection: sqlite3.Connection) -> list[dict]:
    return [dict(row) for row in connection.execute("SELECT wsm_store_no, wsm_store_name FROM wms_store_mst ORDER BY wsm_store_name").fetchall()]


def registration_options(connection: sqlite3.Connection) -> list[dict]:
    return [dict(row) for row in connection.execute("SELECT registration_no, customer_name, mobile_no FROM bus_registration ORDER BY customer_name").fetchall()]


def table_rows(connection: sqlite3.Connection, table_name: str) -> list[dict]:
    if table_name == "products":
        return [dict(row) for row in connection.execute("""SELECT item.item_no, item.item_name, item.item_category, price.rate, price.currency, item.active_status
            FROM bus_item_master AS item JOIN bus_price_list AS price ON price.item_no=item.item_no ORDER BY item.item_no""").fetchall()]
    if table_name == "wms_item_stock":
        return [dict(row) for row in connection.execute("SELECT item_no || '|' || wsm_store_no AS _rowid_, * FROM wms_item_stock ORDER BY last_updated_on DESC LIMIT 250").fetchall()]
    return [dict(row) for row in connection.execute(f"SELECT rowid AS _rowid_, * FROM {table_name} ORDER BY rowid DESC LIMIT 250").fetchall()]


def row_filter(table_name: str, row_id: str) -> tuple[str, list[str | int]]:
    if table_name == "wms_item_stock":
        item_no, store_no = row_id.split("|", 1)
        return "item_no=? AND wsm_store_no=?", [item_no, store_no]
    return "rowid=?", [int(row_id)]


async def save_uploaded_image(upload: UploadFile, prefix: str) -> str:
    extension = ALLOWED_IMAGE_TYPES.get(upload.content_type or "")
    if not extension:
        raise HTTPException(status_code=400, detail="Use a JPG, PNG, or WebP image.")
    content = await upload.read()
    if len(content) > 5 * 1024 * 1024:
        raise HTTPException(status_code=400, detail="Image must be 5 MB or smaller.")
    ITEM_IMAGE_UPLOAD_DIR.mkdir(parents=True, exist_ok=True)
    filename = f"{(prefix or 'item').strip().upper()}-{uuid4().hex}{extension}"
    (ITEM_IMAGE_UPLOAD_DIR / filename).write_bytes(content)
    return f"/static/uploads/items/{filename}"


@router.get("", name="admin")
async def dashboard(request: Request, table: str = "bus_item_master"):
    if not is_admin(request):
        return templates.TemplateResponse(request=request, name="admin_login.html", context={"error": None})
    table = validate_table(table)
    with get_connection() as connection:
        columns = table_columns(connection, table)
        rows = table_rows(connection, table)
        table_counts = {name: connection.execute(f"SELECT COUNT(*) FROM {name}" if name != "products" else "SELECT COUNT(*) FROM bus_item_master").fetchone()[0] for name in TABLES}
        items = item_options(connection)
        categories = category_options(connection)
        stores = store_options(connection)
        customers = registration_options(connection)
    return templates.TemplateResponse(request=request, name="admin.html", context={"tables": TABLES, "table_counts": table_counts, "selected_table": table, "columns": columns, "rows": rows, "items": items, "categories": categories, "stores": stores, "customers": customers, "read_only": table in READ_ONLY_TABLES})


@router.get("/orders", name="admin_orders")
async def order_management(request: Request):
    require_admin(request)
    with get_connection() as connection:
        orders = [dict(row) for row in connection.execute("SELECT order_no, customer_name_snapshot, customer_mobile_snapshot, order_status, payment_status, payable_amount, delivery_address, created_on FROM order_master ORDER BY created_on DESC").fetchall()]
        lines = connection.execute("SELECT order_no, item_no, item_name_snapshot, quantity, unit_price, line_total FROM order_details ORDER BY order_line_no").fetchall()
        invoice_rows = connection.execute("SELECT order_no, sh_invoice_no FROM wms_sh_invheader").fetchall()
        receipt_rows = connection.execute("SELECT header.order_no, payment.sh_mr_no FROM wms_sh_payment AS payment JOIN wms_sh_invheader AS header ON header.sh_invoice_no=payment.sh_invoice_no").fetchall()
    lines_by_order: dict[str, list[dict]] = {}
    for line in lines:
        lines_by_order.setdefault(line["order_no"], []).append(dict(line))
    invoices = {row["order_no"]: row["sh_invoice_no"] for row in invoice_rows}
    receipts = {row["order_no"]: row["sh_mr_no"] for row in receipt_rows}
    for order in orders:
        order["lines"] = lines_by_order.get(order["order_no"], [])
        order["invoice_no"] = invoices.get(order["order_no"])
        order["receipt_no"] = receipts.get(order["order_no"])
    return templates.TemplateResponse(request=request, name="admin_orders.html", context={"orders": orders})


@router.get("/orders/{order_no}/{document_type}", name="admin_order_document")
async def order_document(request: Request, order_no: str, document_type: str):
    require_admin(request)
    if document_type not in {"invoice", "receipt"}:
        raise HTTPException(status_code=404, detail="Unknown document")
    with get_connection() as connection:
        order = connection.execute("SELECT * FROM order_master WHERE order_no=?", (order_no,)).fetchone()
        if not order:
            raise HTTPException(status_code=404, detail="Order not found")
        lines = [dict(row) for row in connection.execute("SELECT item_name_snapshot, quantity, unit_price, line_total FROM order_details WHERE order_no=?", (order_no,)).fetchall()]
        invoice = connection.execute("SELECT sh_invoice_no, sh_invoice_date FROM wms_sh_invheader WHERE order_no=?", (order_no,)).fetchone()
        receipt = connection.execute("SELECT payment.sh_mr_no, payment.sh_payment_date, payment.sh_payment_type FROM wms_sh_payment AS payment JOIN wms_sh_invheader AS header ON header.sh_invoice_no=payment.sh_invoice_no WHERE header.order_no=?", (order_no,)).fetchone()
    return templates.TemplateResponse(request=request, name="admin_document.html", context={"order": dict(order), "lines": lines, "document_type": document_type, "document_no": (invoice["sh_invoice_no"] if document_type == "invoice" and invoice else receipt["sh_mr_no"] if receipt else order_no), "document_date": (invoice["sh_invoice_date"] if document_type == "invoice" and invoice else receipt["sh_payment_date"] if receipt else order["created_on"]), "payment_type": receipt["sh_payment_type"] if receipt else None})


@router.post("/login")
async def login(request: Request, password: str = Form(...)):
    if not hmac.compare_digest(password, ADMIN_PASSWORD):
        return templates.TemplateResponse(request=request, name="admin_login.html", context={"error": "Invalid admin password."}, status_code=401)
    response = RedirectResponse("/admin", status_code=303)
    response.set_cookie(ADMIN_COOKIE, _admin_token(), max_age=60 * 60 * 8, httponly=True, samesite="lax")
    return response


@router.post("/logout")
async def logout():
    response = RedirectResponse("/admin", status_code=303)
    response.delete_cookie(ADMIN_COOKIE)
    return response


@router.post("/tables/{table_name}/rows")
async def add_row(request: Request, table_name: str):
    require_admin(request)
    table_name = validate_table(table_name)
    if table_name in READ_ONLY_TABLES:
        raise HTTPException(status_code=405, detail="Products is a read-only catalog view.")
    with get_connection() as connection:
        column_defs = table_columns(connection, table_name)
        column_names = {column["name"] for column in column_defs}
        date_columns = {column["name"] for column in column_defs if column["is_date"]}
        auto_id_column = next((column["name"] for column in column_defs if column["auto_id"]), None)
        values = await request.form()
        data = {key: value for key, value in values.items() if key in column_names and isinstance(value, str) and value != ""}
        for column_name in date_columns & data.keys():
            data[column_name] = normalize_datetime_value(data[column_name])
        if table_name == "item_image":
            upload = values.get("image_file")
            if upload is not None and getattr(upload, "filename", None):
                data["image_url"] = await save_uploaded_image(upload, values.get("item_no"))
        if auto_id_column:
            data[auto_id_column] = generate_auto_id(connection, table_name, auto_id_column)
        if not data:
            raise HTTPException(status_code=400, detail="Enter at least one value.")
        names = list(data)
        try:
            connection.execute(f"INSERT INTO {table_name} ({','.join(names)}) VALUES ({','.join('?' for _ in names)})", [data[name] for name in names])
        except sqlite3.IntegrityError as error:
            raise HTTPException(status_code=400, detail=f"Could not add row: {error}") from error
    return RedirectResponse(f"/admin?table={table_name}", status_code=303)


@router.post("/tables/{table_name}/rows/{row_id}")
async def update_row(request: Request, table_name: str, row_id: str):
    require_admin(request)
    table_name = validate_table(table_name)
    if table_name in READ_ONLY_TABLES:
        raise HTTPException(status_code=405, detail="Products is a read-only catalog view.")
    with get_connection() as connection:
        column_defs = [column for column in table_columns(connection, table_name) if not column["pk"]]
        column_names = {column["name"] for column in column_defs}
        date_columns = {column["name"] for column in column_defs if column["is_date"]}
        values = await request.form()
        data = {key: value for key, value in values.items() if key in column_names and isinstance(value, str)}
        for column_name in date_columns & data.keys():
            if data[column_name]:
                data[column_name] = normalize_datetime_value(data[column_name])
        if table_name == "item_image":
            upload = values.get("image_file")
            if upload is not None and getattr(upload, "filename", None):
                data["image_url"] = await save_uploaded_image(upload, values.get("item_no"))
            elif not values.get("image_url"):
                data.pop("image_url", None)
        if data:
            where_clause, where_values = row_filter(table_name, row_id)
            try:
                connection.execute(f"UPDATE {table_name} SET {','.join(f'{name}=?' for name in data)} WHERE {where_clause}", [*data.values(), *where_values])
            except sqlite3.IntegrityError as error:
                raise HTTPException(status_code=400, detail=f"Could not update row: {error}") from error
    return RedirectResponse(f"/admin?table={table_name}", status_code=303)


@router.post("/tables/{table_name}/rows/{row_id}/delete")
async def delete_row(request: Request, table_name: str, row_id: str):
    require_admin(request)
    table_name = validate_table(table_name)
    if table_name in READ_ONLY_TABLES:
        raise HTTPException(status_code=405, detail="Products is a read-only catalog view.")
    with get_connection() as connection:
        where_clause, where_values = row_filter(table_name, row_id)
        connection.execute(f"DELETE FROM {table_name} WHERE {where_clause}", where_values)
    return RedirectResponse(f"/admin?table={table_name}", status_code=303)


@router.post("/items")
async def create_item(request: Request, item_no: str = Form(...), item_name: str = Form(...), item_category: str = Form(...), item_description: str = Form(""), item_type: str = Form("Decor"), display_tone: str = Form("sand"), display_type: str = Form("vase"), rate: float = Form(...), currency: str = Form("TK."), stock: int = Form(0)):
    require_admin(request)
    with get_connection() as connection:
        connection.execute("INSERT INTO bus_item_master (item_no,item_type,item_category,item_name,item_description,made_in,display_tone,display_type,product_tag) VALUES (?,?,?,?,?,?,?,?,?)", (item_no.strip().upper(), item_type, item_category, item_name, item_description, "Bangladesh", display_tone, display_type, "New arrival"))
        connection.execute("INSERT INTO bus_price_list (item_no,rate,currency) VALUES (?,?,?)", (item_no.strip().upper(), rate, currency))
        connection.execute("INSERT OR REPLACE INTO wms_item_stock (item_no,wsm_store_no,available_quantity) VALUES (?, 'VL-MAIN', ?)", (item_no.strip().upper(), stock))
    return RedirectResponse("/admin", status_code=303)


@router.post("/images")
async def add_image(request: Request, item_no: str = Form(...), image_url: str = Form(...), alt_text: str = Form(""), display_order: int = Form(1)):
    require_admin(request)
    with get_connection() as connection:
        connection.execute("INSERT INTO item_image (item_no,image_url,alt_text,display_order) VALUES (?,?,?,?)", (item_no.strip().upper(), image_url, alt_text, display_order))
    return RedirectResponse("/admin", status_code=303)


@router.post("/images/{image_id}/delete")
async def delete_image(request: Request, image_id: int):
    require_admin(request)
    with get_connection() as connection:
        connection.execute("UPDATE item_image SET active_status='N' WHERE image_id=?", (image_id,))
    return RedirectResponse("/admin", status_code=303)


@router.post("/flash-sales")
async def create_flash_sale(request: Request, item_no: str = Form(...), sale_price: float = Form(...), currency: str = Form("TK."), starts_on: str = Form(...), ends_on: str = Form(...)):
    require_admin(request)
    with get_connection() as connection:
        connection.execute("INSERT INTO flash_sale (item_no,sale_price,currency,starts_on,ends_on) VALUES (?,?,?,?,?)", (item_no.strip().upper(), sale_price, currency, starts_on, ends_on))
    return RedirectResponse("/admin", status_code=303)


@router.post("/flash-sales/{sale_id}/delete")
async def delete_flash_sale(request: Request, sale_id: int):
    require_admin(request)
    with get_connection() as connection:
        connection.execute("UPDATE flash_sale SET active_status='N' WHERE flash_sale_id=?", (sale_id,))
    return RedirectResponse("/admin", status_code=303)


@router.post("/orders/{order_no}/status")
async def update_order_status(request: Request, order_no: str, order_status: str = Form(...)):
    require_admin(request)
    allowed = {"PENDING", "CONFIRMED", "PROCESSING", "SHIPPED", "DELIVERED", "CANCELLED"}
    if order_status not in allowed:
        raise HTTPException(status_code=400, detail="Invalid order status")
    with get_connection() as connection:
        connection.execute("UPDATE order_master SET order_status=? WHERE order_no=?", (order_status, order_no))
    return RedirectResponse("/admin/orders", status_code=303)
