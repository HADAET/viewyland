from pathlib import Path
import hashlib
import hmac
import os
import re
from datetime import datetime
from uuid import uuid4

import psycopg2

from fastapi import APIRouter, Form, HTTPException, Request, UploadFile
from fastapi.responses import RedirectResponse
from fastapi.templating import Jinja2Templates

from app.db.database import get_connection


router = APIRouter(prefix="/admin", tags=["admin"])

BASE_DIR = Path(__file__).resolve().parent.parent
templates = Jinja2Templates(directory=BASE_DIR / "templates")

ADMIN_COOKIE = "viewyland_admin"
ADMIN_PASSWORD = os.getenv("VIEWYLAND_ADMIN_PASSWORD", "change-me")

ITEM_IMAGE_UPLOAD_DIR = Path("app/static/uploads/items")

ALLOWED_IMAGE_TYPES = {
    "image/jpeg": ".jpg",
    "image/png": ".png",
    "image/webp": ".webp",
}

DATETIME_LOCAL_PATTERN = re.compile(
    r"^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}$"
)

AUTO_ID_PREFIXES = {
    "bus_registration": "CUS",
    "wms_store_mst": "ST",
    "order_master": "ORD",
    "wms_sh_invheader": "INV",
    "wms_sh_payment": "MR",
}

TABLES = [
    "bus_item_master",
    "bus_item_category",
    "bus_price_list",
    "bus_registration",
    "flash_sale",
    "item_image",
    "order_details",
    "order_master",
    "products",
    "wms_item_stock",
    "wms_sh_invheader",
    "wms_sh_invline",
    "wms_sh_payment",
    "wms_store_mst",
]

READ_ONLY_TABLES = {"products"}

# =========================================================
# PAGINATION / SEARCH / SORT DEFAULTS
# =========================================================

PAGE_SIZE_CHOICES = (25, 50, 100, 250)
DEFAULT_PAGE_SIZE = 50

# Column types treated as free-text for the search box (ILIKE).
TEXT_COLUMN_TYPES = {
    "TEXT",
    "CHARACTER VARYING",
    "VARCHAR",
    "CHAR",
    "CHARACTER",
}


# =========================================================
# ADMIN AUTH
# =========================================================

def _admin_token() -> str:
    return hashlib.sha256(
        ADMIN_PASSWORD.encode()
    ).hexdigest()


def is_admin(request: Request) -> bool:
    return hmac.compare_digest(
        request.cookies.get(ADMIN_COOKIE, ""),
        _admin_token(),
    )


def require_admin(request: Request):
    if not is_admin(request):
        raise HTTPException(
            status_code=401,
            detail="Admin login required",
        )


# =========================================================
# VALIDATION
# =========================================================

def validate_table(table_name: str) -> str:
    if table_name not in TABLES:
        raise HTTPException(
            status_code=404,
            detail="Unknown table",
        )

    return table_name


# =========================================================
# TABLE METADATA
# =========================================================

def table_columns(
    connection,
    table_name: str,
) -> list[dict]:

    # products is a virtual/read-only catalog view.
    if table_name == "products":
        return [
            {
                "name": "item_no",
                "type": "TEXT",
                "notnull": 1,
                "pk": 1,
                "auto_id": False,
                "is_date": False,
            },
            {
                "name": "item_name",
                "type": "TEXT",
                "notnull": 1,
                "pk": 0,
                "auto_id": False,
                "is_date": False,
            },
            {
                "name": "item_category",
                "type": "TEXT",
                "notnull": 1,
                "pk": 0,
                "auto_id": False,
                "is_date": False,
            },
            {
                "name": "rate",
                "type": "REAL",
                "notnull": 1,
                "pk": 0,
                "auto_id": False,
                "is_date": False,
            },
            {
                "name": "currency",
                "type": "TEXT",
                "notnull": 1,
                "pk": 0,
                "auto_id": False,
                "is_date": False,
            },
            {
                "name": "active_status",
                "type": "TEXT",
                "notnull": 1,
                "pk": 0,
                "auto_id": False,
                "is_date": False,
            },
        ]

    columns = [
        dict(row)
        for row in connection.execute(
            """
            SELECT
                c.column_name AS name,
                UPPER(c.data_type) AS type,

                CASE
                    WHEN c.is_nullable = 'NO'
                    THEN 1
                    ELSE 0
                END AS notnull,

                CASE
                    WHEN pk.column_name IS NOT NULL
                    THEN 1
                    ELSE 0
                END AS pk

            FROM information_schema.columns c

            LEFT JOIN (
                SELECT
                    kcu.column_name

                FROM information_schema.table_constraints tc

                JOIN information_schema.key_column_usage kcu
                    ON tc.constraint_name = kcu.constraint_name
                    AND tc.table_schema = kcu.table_schema

                WHERE tc.table_name = ?
                  AND tc.constraint_type = 'PRIMARY KEY'
            ) pk
                ON pk.column_name = c.column_name

            WHERE c.table_name = ?

            ORDER BY c.ordinal_position
            """,
            (table_name, table_name),
        ).fetchall()
    ]

    pk_columns = [
        column
        for column in columns
        if column["pk"]
    ]

    # Only a single TEXT primary key is treated as an
    # auto-generated identity.
    auto_id_name = (
        pk_columns[0]["name"]
        if (
            len(pk_columns) == 1
            and pk_columns[0]["type"].upper() == "TEXT"
        )
        else None
    )

    for column in columns:
        column["auto_id"] = (
            column["name"] == auto_id_name
        )

        column["is_date"] = column["name"].endswith(
            ("_on", "_date")
        )

    # -----------------------------------------------------
    # VIRTUAL item_name COLUMN
    # -----------------------------------------------------
    #
    # Many tables reference a product only by item_no (a
    # foreign key into bus_item_master) and have no item_name
    # column of their own. Rather than storing item_name a
    # second time in every such table (duplication + goes
    # stale on rename), we inject a READ-ONLY virtual column
    # here, right after item_no, so the admin table view shows
    # both the code and the product name. table_rows() fills
    # its value in-memory from bus_item_master via a lookup —
    # nothing is written to the database for it.
    #
    # marked "virtual": True so:
    #   - add_row()/update_row() never accept it as real input
    #   - admin.js never renders an editable field for it
    # -----------------------------------------------------

    has_item_no = any(
        column["name"] == "item_no"
        for column in columns
    )

    has_item_name = any(
        column["name"] == "item_name"
        for column in columns
    )

    if has_item_no and not has_item_name:

        item_no_index = next(
            index
            for index, column in enumerate(columns)
            if column["name"] == "item_no"
        )

        columns.insert(
            item_no_index + 1,
            {
                "name": "item_name",
                "type": "TEXT",
                "notnull": 0,
                "pk": 0,
                "auto_id": False,
                "is_date": False,
                "virtual": True,
            },
        )

    return columns


# =========================================================
# ID GENERATION
# =========================================================

def generate_auto_id(
    connection,
    table_name: str,
    column_name: str,
) -> str:

    if table_name == "bus_item_master":

        next_number = 1

        rows = connection.execute(
            """
            SELECT item_no
            FROM bus_item_master
            WHERE item_no LIKE 'VL-%'
            """
        ).fetchall()

        for row in rows:
            item_no = row["item_no"]
            suffix = item_no.rsplit("-", 1)[-1]

            if suffix.isdigit():
                next_number = max(
                    next_number,
                    int(suffix) + 1,
                )

        return f"VL-{next_number:03d}"

    prefix = AUTO_ID_PREFIXES.get(
        table_name,
        table_name[:3].upper(),
    )

    return (
        f"{prefix}-"
        f"{datetime.now():%Y%m%d}-"
        f"{uuid4().hex[:8].upper()}"
    )


# =========================================================
# GENERAL HELPERS
# =========================================================

def normalize_datetime_value(value: str) -> str:
    if DATETIME_LOCAL_PATTERN.match(value):
        return value.replace("T", " ") + ":00"

    return value


def item_options(connection) -> list[dict]:
    return [
        dict(row)
        for row in connection.execute(
            """
            SELECT item_no, item_name
            FROM bus_item_master
            ORDER BY item_name
            """
        ).fetchall()
    ]


def category_options(connection) -> list[str]:
    return [
        row["category_name"]
        for row in connection.execute(
            """
            SELECT category_name
            FROM bus_item_category
            WHERE active_status = 'Y'
            ORDER BY category_name
            """
        ).fetchall()
    ]


def store_options(connection) -> list[dict]:
    return [
        dict(row)
        for row in connection.execute(
            """
            SELECT
                wsm_store_no,
                wsm_store_name
            FROM wms_store_mst
            ORDER BY wsm_store_name
            """
        ).fetchall()
    ]


def registration_options(connection) -> list[dict]:
    return [
        dict(row)
        for row in connection.execute(
            """
            SELECT
                registration_no,
                customer_name,
                mobile_no
            FROM bus_registration
            ORDER BY customer_name
            """
        ).fetchall()
    ]


# =========================================================
# OPTIMIZED TABLE COUNTS
# =========================================================
#
# BEFORE:
#   14 separate SELECT COUNT(*) queries
#
# NOW:
#   ONE PostgreSQL round-trip
#
# This is important because your PostgreSQL round-trip is
# currently around 238-240ms.
# =========================================================

def get_table_counts(connection) -> dict[str, int]:

    row = connection.execute(
        """
        SELECT

            (SELECT COUNT(*)
             FROM bus_item_master)
                AS bus_item_master,

            (SELECT COUNT(*)
             FROM bus_item_category)
                AS bus_item_category,

            (SELECT COUNT(*)
             FROM bus_price_list)
                AS bus_price_list,

            (SELECT COUNT(*)
             FROM bus_registration)
                AS bus_registration,

            (SELECT COUNT(*)
             FROM flash_sale)
                AS flash_sale,

            (SELECT COUNT(*)
             FROM item_image)
                AS item_image,

            (SELECT COUNT(*)
             FROM order_details)
                AS order_details,

            (SELECT COUNT(*)
             FROM order_master)
                AS order_master,

            (SELECT COUNT(*)
             FROM bus_item_master)
                AS products,

            (SELECT COUNT(*)
             FROM wms_item_stock)
                AS wms_item_stock,

            (SELECT COUNT(*)
             FROM wms_sh_invheader)
                AS wms_sh_invheader,

            (SELECT COUNT(*)
             FROM wms_sh_invline)
                AS wms_sh_invline,

            (SELECT COUNT(*)
             FROM wms_sh_payment)
                AS wms_sh_payment,

            (SELECT COUNT(*)
             FROM wms_store_mst)
                AS wms_store_mst
        """
    ).fetchone()

    return {
        name: row[name]
        for name in TABLES
    }


# =========================================================
# TABLE ROWS
# =========================================================

# =========================================================
# ITEM NAME LOOKUP (no extra query, no duplicate storage)
# =========================================================

def _attach_item_names(rows: list[dict], items: list[dict] | None) -> None:
    """
    Fill in row["item_name"] from an already-fetched
    item_no -> item_name lookup (item_options()), for any
    row that has an item_no but no item_name of its own.

    Mutates `rows` in place. No-op if there's nothing to do —
    keeps this cheap for tables that don't reference items.
    """

    if not items or not rows:
        return

    if "item_no" not in rows[0] or "item_name" in rows[0]:
        return

    item_name_by_no = {
        item["item_no"]: item["item_name"]
        for item in items
    }

    for row in rows:
        row["item_name"] = item_name_by_no.get(
            row["item_no"], ""
        )


def table_rows(
    connection,
    table_name: str,
    columns=None,
    items: list[dict] | None = None,
    search: str | None = None,
    sort: str | None = None,
    sort_dir: str | None = None,
    page: int = 1,
    page_size: int = DEFAULT_PAGE_SIZE,
) -> tuple[list[dict], int]:
    """
    Returns (rows, total_row_count) for one page of a table,
    with an optional free-text search and column sort applied.

    total_row_count is the count BEFORE pagination — the
    caller uses it to render "page X of Y" / prev-next controls.
    """

    # -----------------------------------------------------
    # Virtual products table
    # -----------------------------------------------------

    if table_name == "products":

        if columns is None:
            columns = table_columns(connection, table_name)

        base_sql = """
            SELECT
                item.item_no AS item_no,
                item.item_name AS item_name,
                item.item_category AS item_category,
                price.rate AS rate,
                price.currency AS currency,
                item.active_status AS active_status
            FROM bus_item_master AS item
            JOIN bus_price_list AS price
                ON price.item_no = item.item_no
        """

        real_columns = [c for c in columns if not c.get("virtual")]

        return _search_sort_paginate(
            connection,
            base_sql,
            searchable_columns=[
                c["name"] for c in real_columns
                if c["type"].upper() in TEXT_COLUMN_TYPES
            ],
            sortable_columns={c["name"]: c["name"] for c in real_columns},
            default_sort="item_no ASC",
            search=search,
            sort=sort,
            sort_dir=sort_dir,
            page=page,
            page_size=page_size,
        )

    # -----------------------------------------------------
    # Composite primary-key table
    # -----------------------------------------------------

    if table_name == "wms_item_stock":

        if columns is None:
            columns = table_columns(connection, table_name)

        base_sql = """
            SELECT
                item_no || '|' || wsm_store_no AS _rowid_,
                *
            FROM wms_item_stock
        """

        real_columns = [c for c in columns if not c.get("virtual")]

        rows, total = _search_sort_paginate(
            connection,
            base_sql,
            searchable_columns=[
                c["name"] for c in real_columns
                if c["type"].upper() in TEXT_COLUMN_TYPES
            ],
            sortable_columns={c["name"]: c["name"] for c in real_columns},
            default_sort="last_updated_on DESC",
            search=search,
            sort=sort,
            sort_dir=sort_dir,
            page=page,
            page_size=page_size,
        )

        _attach_item_names(rows, items)

        return rows, total

    # -----------------------------------------------------
    # IMPORTANT:
    #
    # Reuse columns that dashboard() already fetched.
    #
    # Previously this called table_columns() AGAIN.
    # -----------------------------------------------------

    if columns is None:
        columns = table_columns(
            connection,
            table_name,
        )

    pk_columns = [
        column
        for column in columns
        if column["pk"]
    ]

    if not pk_columns:
        raise HTTPException(
            status_code=500,
            detail=f"No primary key found for table: {table_name}",
        )

    pk_column = pk_columns[0]["name"]

    real_columns = [c for c in columns if not c.get("virtual")]

    base_sql = f"""
        SELECT
            {pk_column} AS _rowid_,
            *
        FROM {table_name}
    """

    rows, total = _search_sort_paginate(
        connection,
        base_sql,
        searchable_columns=[
            c["name"] for c in real_columns
            if c["type"].upper() in TEXT_COLUMN_TYPES
        ],
        sortable_columns={c["name"]: c["name"] for c in real_columns},
        default_sort=f"{pk_column} DESC",
        search=search,
        sort=sort,
        sort_dir=sort_dir,
        page=page,
        page_size=page_size,
    )

    _attach_item_names(rows, items)

    return rows, total


def _search_sort_paginate(
    connection,
    base_sql: str,
    searchable_columns: list[str],
    sortable_columns: dict[str, str],
    default_sort: str,
    search: str | None,
    sort: str | None,
    sort_dir: str | None,
    page: int,
    page_size: int,
) -> tuple[list[dict], int]:
    """
    Shared by every table_rows() branch: wraps a base SELECT
    (already producing its final, plain output column names)
    with an optional search filter, a whitelisted ORDER BY,
    and LIMIT/OFFSET pagination — so search/sort/pagination
    behave identically no matter which table is being viewed.

    `sortable_columns` and `search` are both applied to the
    OUTER wrapping query, so callers just list plain output
    column names — no need to worry about join qualifiers.
    """

    where_sql = ""
    where_params: list = []

    if search and searchable_columns:
        conditions = " OR ".join(
            f"{column}::text ILIKE ?" for column in searchable_columns
        )
        where_sql = f" WHERE ({conditions})"
        where_params = [f"%{search}%"] * len(searchable_columns)

    direction = "DESC" if (sort_dir or "").lower() == "desc" else "ASC"
    order_sql = (
        f"{sortable_columns[sort]} {direction}"
        if sort and sort in sortable_columns
        else default_sort
    )

    total = connection.execute(
        f"SELECT COUNT(*) AS total FROM ({base_sql}) AS counted{where_sql}",
        where_params,
    ).fetchone()["total"]

    page = max(page, 1)
    offset = (page - 1) * page_size

    rows = [
        dict(row)
        for row in connection.execute(
            f"""
            SELECT * FROM ({base_sql}) AS wrapped{where_sql}
            ORDER BY {order_sql}
            LIMIT ? OFFSET ?
            """,
            where_params + [page_size, offset],
        ).fetchall()
    ]

    return rows, total


# =========================================================
# ROW FILTER
# =========================================================

def row_filter(
    connection,
    table_name: str,
    row_id: str,
) -> tuple[str, list[str | int]]:

    if table_name == "wms_item_stock":

        item_no, store_no = row_id.split("|", 1)

        return (
            "item_no=? AND wsm_store_no=?",
            [item_no, store_no],
        )

    columns = table_columns(
        connection,
        table_name,
    )

    pk_column = next(
        column
        for column in columns
        if column["pk"]
    )

    value = (
        row_id
        if pk_column["type"].upper() == "TEXT"
        else int(row_id)
    )

    return (
        f"{pk_column['name']}=?",
        [value],
    )


# =========================================================
# IMAGE UPLOAD
# =========================================================

async def save_uploaded_image(
    upload: UploadFile,
    prefix: str,
) -> str:

    extension = ALLOWED_IMAGE_TYPES.get(
        upload.content_type or ""
    )

    if not extension:
        raise HTTPException(
            status_code=400,
            detail="Use a JPG, PNG, or WebP image.",
        )

    content = await upload.read()

    if len(content) > 5 * 1024 * 1024:
        raise HTTPException(
            status_code=400,
            detail="Image must be 5 MB or smaller.",
        )

    ITEM_IMAGE_UPLOAD_DIR.mkdir(
        parents=True,
        exist_ok=True,
    )

    filename = (
        f"{(prefix or 'item').strip().upper()}-"
        f"{uuid4().hex}"
        f"{extension}"
    )

    (
        ITEM_IMAGE_UPLOAD_DIR / filename
    ).write_bytes(content)

    return f"/static/uploads/items/{filename}"


# =========================================================
# ADMIN DASHBOARD
# =========================================================

@router.get("", name="admin")
async def dashboard(
    request: Request,
    table: str = "bus_item_master",
    page: int = 1,
    page_size: int = DEFAULT_PAGE_SIZE,
    q: str | None = None,
    sort: str | None = None,
    dir: str = "asc",
):

    if not is_admin(request):
        return templates.TemplateResponse(
            request=request,
            name="admin_login.html",
            context={"error": None},
        )

    table = validate_table(table)

    page = max(page, 1)
    page_size = (
        page_size
        if page_size in PAGE_SIZE_CHOICES
        else DEFAULT_PAGE_SIZE
    )
    search = (q or "").strip() or None
    sort = (sort or "").strip() or None
    sort_dir = "desc" if dir == "desc" else "asc"

    with get_connection() as connection:

        # Fetch metadata ONCE.
        columns = table_columns(
            connection,
            table,
        )

        # Needed by table_rows() below to fill in the virtual
        # item_name column — fetch it first so it's reused,
        # not queried twice.
        items = item_options(connection)

        # Reuse the metadata + items above.
        rows, total_rows = table_rows(
            connection,
            table,
            columns,
            items,
            search=search,
            sort=sort,
            sort_dir=sort_dir,
            page=page,
            page_size=page_size,
        )

        # ONE query instead of 14 COUNT queries.
        table_counts = get_table_counts(
            connection
        )

        categories = category_options(
            connection
        )

        stores = store_options(
            connection
        )

        customers = registration_options(
            connection
        )

    total_pages = max(
        (total_rows + page_size - 1) // page_size,
        1,
    )

    return templates.TemplateResponse(
        request=request,
        name="admin.html",
        context={
            "tables": TABLES,
            "table_counts": table_counts,
            "selected_table": table,
            "columns": columns,
            "rows": rows,
            "items": items,
            "categories": categories,
            "stores": stores,
            "customers": customers,
            "read_only": table in READ_ONLY_TABLES,
            "page": page,
            "page_size": page_size,
            "page_size_choices": PAGE_SIZE_CHOICES,
            "total_rows": total_rows,
            "total_pages": total_pages,
            "search": search or "",
            "sort": sort or "",
            "sort_dir": sort_dir,
        },
    )


# =========================================================
# ADMIN ORDERS
# =========================================================

@router.get("/orders", name="admin_orders")
async def order_management(
    request: Request,
):

    if not is_admin(request):
        return templates.TemplateResponse(
            request=request,
            name="admin_login.html",
            context={"error": None},
        )

    with get_connection() as connection:

        orders = [
            dict(row)
            for row in connection.execute(
                """
                SELECT
                    order_no,
                    customer_name_snapshot,
                    customer_mobile_snapshot,
                    order_status,
                    payment_status,
                    payable_amount,
                    delivery_address,
                    created_on

                FROM order_master

                ORDER BY created_on DESC
                """
            ).fetchall()
        ]

        lines = connection.execute(
            """
            SELECT
                od.order_no,
                od.item_no,
                od.item_name_snapshot,
                od.quantity,
                od.unit_price,
                od.line_total,
                img.image_url

            FROM order_details od

            LEFT JOIN item_image img
                ON od.item_no = img.item_no
                AND img.active_status = 'Y'
                AND (
                    img.display_order = 1
                    OR img.display_order IS NULL
                )

            ORDER BY od.order_line_no
            """
        ).fetchall()

        invoice_rows = connection.execute(
            """
            SELECT
                order_no,
                sh_invoice_no
            FROM wms_sh_invheader
            """
        ).fetchall()

        receipt_rows = connection.execute(
            """
            SELECT
                header.order_no,
                payment.sh_mr_no

            FROM wms_sh_payment AS payment

            JOIN wms_sh_invheader AS header
                ON header.sh_invoice_no =
                   payment.sh_invoice_no
            """
        ).fetchall()

    lines_by_order: dict[str, list[dict]] = {}

    for line in lines:
        lines_by_order.setdefault(
            line["order_no"],
            [],
        ).append(dict(line))

    invoices = {
        row["order_no"]: row["sh_invoice_no"]
        for row in invoice_rows
    }

    receipts = {
        row["order_no"]: row["sh_mr_no"]
        for row in receipt_rows
    }

    for order in orders:

        order["lines"] = lines_by_order.get(
            order["order_no"],
            [],
        )

        order["invoice_no"] = invoices.get(
            order["order_no"]
        )

        order["receipt_no"] = receipts.get(
            order["order_no"]
        )

    return templates.TemplateResponse(
        request=request,
        name="admin_orders.html",
        context={
            "orders": orders,
        },
    )


# =========================================================
# ORDER DOCUMENT
# =========================================================

@router.get(
    "/orders/{order_no}/{document_type}",
    name="admin_order_document",
)
async def order_document(
    request: Request,
    order_no: str,
    document_type: str,
):

    require_admin(request)

    if document_type not in {
        "invoice",
        "receipt",
    }:
        raise HTTPException(
            status_code=404,
            detail="Unknown document",
        )

    with get_connection() as connection:

        order = connection.execute(
            """
            SELECT *
            FROM order_master
            WHERE order_no=?
            """,
            (order_no,),
        ).fetchone()

        if not order:
            raise HTTPException(
                status_code=404,
                detail="Order not found",
            )

        lines = [
            dict(row)
            for row in connection.execute(
                """
                SELECT
                    item_name_snapshot,
                    quantity,
                    unit_price,
                    line_total

                FROM order_details

                WHERE order_no=?
                """,
                (order_no,),
            ).fetchall()
        ]

        invoice = connection.execute(
            """
            SELECT
                sh_invoice_no,
                sh_invoice_date

            FROM wms_sh_invheader

            WHERE order_no=?
            """,
            (order_no,),
        ).fetchone()

        receipt = connection.execute(
            """
            SELECT
                payment.sh_mr_no,
                payment.sh_payment_date,
                payment.sh_payment_type

            FROM wms_sh_payment AS payment

            JOIN wms_sh_invheader AS header
                ON header.sh_invoice_no =
                   payment.sh_invoice_no

            WHERE header.order_no=?
            """,
            (order_no,),
        ).fetchone()

    if (
        document_type == "invoice"
        and invoice
    ):
        document_no = invoice["sh_invoice_no"]
        document_date = invoice["sh_invoice_date"]

    elif receipt:
        document_no = receipt["sh_mr_no"]
        document_date = receipt["sh_payment_date"]

    else:
        document_no = order_no
        document_date = order["created_on"]

    return templates.TemplateResponse(
        request=request,
        name="admin_document.html",
        context={
            "order": dict(order),
            "lines": lines,
            "document_type": document_type,
            "document_no": document_no,
            "document_date": document_date,
            "payment_type": (
                receipt["sh_payment_type"]
                if receipt
                else None
            ),
        },
    )


# =========================================================
# LOGIN
# =========================================================

@router.post("/login")
async def login(
    request: Request,
    password: str = Form(...),
):

    if not hmac.compare_digest(
        password,
        ADMIN_PASSWORD,
    ):
        return templates.TemplateResponse(
            request=request,
            name="admin_login.html",
            context={
                "error": "Invalid admin password."
            },
            status_code=401,
        )

    response = RedirectResponse(
        "/admin",
        status_code=303,
    )

    response.set_cookie(
        ADMIN_COOKIE,
        _admin_token(),
        max_age=60 * 60 * 8,
        httponly=True,
        samesite="lax",
    )

    return response


# =========================================================
# LOGOUT
# =========================================================

@router.post("/logout")
async def logout():

    response = RedirectResponse(
        "/admin",
        status_code=303,
    )

    response.delete_cookie(
        ADMIN_COOKIE
    )

    return response


# =========================================================
# ADD GENERIC TABLE ROW
# =========================================================

@router.post("/tables/{table_name}/rows")
async def add_row(
    request: Request,
    table_name: str,
):

    require_admin(request)

    table_name = validate_table(
        table_name
    )

    if table_name in READ_ONLY_TABLES:
        raise HTTPException(
            status_code=405,
            detail="Products is a read-only catalog view.",
        )

    with get_connection() as connection:

        column_defs = table_columns(
            connection,
            table_name,
        )

        column_names = {
            column["name"]
            for column in column_defs
            if not column.get("virtual")
        }

        date_columns = {
            column["name"]
            for column in column_defs
            if column["is_date"]
        }

        auto_id_column = next(
            (
                column["name"]
                for column in column_defs
                if column["auto_id"]
            ),
            None,
        )

        values = await request.form()

        data = {
            key: value
            for key, value in values.items()
            if (
                key in column_names
                and isinstance(value, str)
                and value != ""
            )
        }

        for column_name in (
            date_columns & data.keys()
        ):
            data[column_name] = normalize_datetime_value(
                data[column_name]
            )

        if table_name == "item_image":

            upload = values.get("image_file")

            if (
                upload is not None
                and getattr(
                    upload,
                    "filename",
                    None,
                )
            ):
                data["image_url"] = (
                    await save_uploaded_image(
                        upload,
                        values.get("item_no"),
                    )
                )

        if auto_id_column:
            data[auto_id_column] = generate_auto_id(
                connection,
                table_name,
                auto_id_column,
            )

        if not data:
            raise HTTPException(
                status_code=400,
                detail="Enter at least one value.",
            )

        names = list(data)

        try:

            connection.execute(
                f"""
                INSERT INTO {table_name}
                    ({','.join(names)})
                VALUES
                    ({','.join('?' for _ in names)})
                """,
                [
                    data[name]
                    for name in names
                ],
            )

        except psycopg2.IntegrityError as error:

            raise HTTPException(
                status_code=400,
                detail=f"Could not add row: {error}",
            ) from error

    return RedirectResponse(
        f"/admin?table={table_name}",
        status_code=303,
    )


# =========================================================
# UPDATE GENERIC TABLE ROW
# =========================================================

@router.post(
    "/tables/{table_name}/rows/{row_id}"
)
async def update_row(
    request: Request,
    table_name: str,
    row_id: str,
):

    require_admin(request)

    table_name = validate_table(
        table_name
    )

    if table_name in READ_ONLY_TABLES:
        raise HTTPException(
            status_code=405,
            detail="Products is a read-only catalog view.",
        )

    with get_connection() as connection:

        column_defs = [
            column
            for column in table_columns(
                connection,
                table_name,
            )
            if not column["pk"] and not column.get("virtual")
        ]

        column_names = {
            column["name"]
            for column in column_defs
        }

        date_columns = {
            column["name"]
            for column in column_defs
            if column["is_date"]
        }

        values = await request.form()

        data = {
            key: value
            for key, value in values.items()
            if (
                key in column_names
                and isinstance(value, str)
            )
        }

        for column_name in (
            date_columns & data.keys()
        ):
            if data[column_name]:
                data[column_name] = normalize_datetime_value(
                    data[column_name]
                )

        if table_name == "item_image":

            upload = values.get("image_file")

            if (
                upload is not None
                and getattr(
                    upload,
                    "filename",
                    None,
                )
            ):

                data["image_url"] = (
                    await save_uploaded_image(
                        upload,
                        values.get("item_no"),
                    )
                )

            elif not values.get("image_url"):
                data.pop(
                    "image_url",
                    None,
                )

        if data:

            where_clause, where_values = row_filter(
                connection,
                table_name,
                row_id,
            )

            try:

                connection.execute(
                    f"""
                    UPDATE {table_name}
                    SET {
                        ','.join(
                            f"{name}=?"
                            for name in data
                        )
                    }
                    WHERE {where_clause}
                    """,
                    [
                        *data.values(),
                        *where_values,
                    ],
                )

            except psycopg2.IntegrityError as error:

                raise HTTPException(
                    status_code=400,
                    detail=f"Could not update row: {error}",
                ) from error

    return RedirectResponse(
        f"/admin?table={table_name}",
        status_code=303,
    )


# =========================================================
# DELETE GENERIC TABLE ROW
# =========================================================

@router.post(
    "/tables/{table_name}/rows/{row_id}/delete"
)
async def delete_row(
    request: Request,
    table_name: str,
    row_id: str,
):

    require_admin(request)

    table_name = validate_table(
        table_name
    )

    if table_name in READ_ONLY_TABLES:
        raise HTTPException(
            status_code=405,
            detail="Products is a read-only catalog view.",
        )

    with get_connection() as connection:

        where_clause, where_values = row_filter(
            connection,
            table_name,
            row_id,
        )

        connection.execute(
            f"""
            DELETE FROM {table_name}
            WHERE {where_clause}
            """,
            where_values,
        )

    return RedirectResponse(
        f"/admin?table={table_name}",
        status_code=303,
    )


# =========================================================
# CREATE ITEM
# =========================================================

@router.post("/items")
async def create_item(
    request: Request,
    item_no: str = Form(...),
    item_name: str = Form(...),
    item_category: str = Form(...),
    item_description: str = Form(""),
    item_type: str = Form("Decor"),
    display_tone: str = Form("sand"),
    display_type: str = Form("vase"),
    rate: float = Form(...),
    currency: str = Form("TK."),
    stock: int = Form(0),
):

    require_admin(request)

    item_no = item_no.strip().upper()

    with get_connection() as connection:

        connection.execute(
            """
            INSERT INTO bus_item_master
            (
                item_no,
                item_type,
                item_category,
                item_name,
                item_description,
                made_in,
                display_tone,
                display_type,
                product_tag
            )
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
            """,
            (
                item_no,
                item_type,
                item_category,
                item_name,
                item_description,
                "Bangladesh",
                display_tone,
                display_type,
                "New arrival",
            ),
        )

        connection.execute(
            """
            INSERT INTO bus_price_list
                (item_no, rate, currency)
            VALUES (?, ?, ?)
            """,
            (
                item_no,
                rate,
                currency,
            ),
        )

        connection.execute(
            """
            INSERT INTO wms_item_stock
                (
                    item_no,
                    wsm_store_no,
                    available_quantity
                )
            VALUES (?, 'VL-MAIN', ?)

            ON CONFLICT (
                item_no,
                wsm_store_no
            )
            DO UPDATE SET
                available_quantity =
                    EXCLUDED.available_quantity
            """,
            (
                item_no,
                stock,
            ),
        )

    return RedirectResponse(
        "/admin",
        status_code=303,
    )


# =========================================================
# ADD IMAGE
# =========================================================

@router.post("/images")
async def add_image(
    request: Request,
    item_no: str = Form(...),
    image_url: str = Form(...),
    alt_text: str = Form(""),
    display_order: int = Form(1),
):

    require_admin(request)

    with get_connection() as connection:

        connection.execute(
            """
            INSERT INTO item_image
                (
                    item_no,
                    image_url,
                    alt_text,
                    display_order
                )
            VALUES (?, ?, ?, ?)
            """,
            (
                item_no.strip().upper(),
                image_url,
                alt_text,
                display_order,
            ),
        )

    return RedirectResponse(
        "/admin",
        status_code=303,
    )


# =========================================================
# DELETE IMAGE
# =========================================================

@router.post(
    "/images/{image_id}/delete"
)
async def delete_image(
    request: Request,
    image_id: int,
):

    require_admin(request)

    with get_connection() as connection:

        connection.execute(
            """
            UPDATE item_image
            SET active_status='N'
            WHERE image_id=?
            """,
            (image_id,),
        )

    return RedirectResponse(
        "/admin",
        status_code=303,
    )


# =========================================================
# CREATE FLASH SALE
# =========================================================

@router.post("/flash-sales")
async def create_flash_sale(
    request: Request,
    item_no: str = Form(...),
    sale_price: float = Form(...),
    currency: str = Form("TK."),
    starts_on: str = Form(...),
    ends_on: str = Form(...),
):

    require_admin(request)

    with get_connection() as connection:

        connection.execute(
            """
            INSERT INTO flash_sale
                (
                    item_no,
                    sale_price,
                    currency,
                    starts_on,
                    ends_on
                )
            VALUES (?, ?, ?, ?, ?)
            """,
            (
                item_no.strip().upper(),
                sale_price,
                currency,
                starts_on,
                ends_on,
            ),
        )

    return RedirectResponse(
        "/admin",
        status_code=303,
    )


# =========================================================
# DELETE FLASH SALE
# =========================================================

@router.post(
    "/flash-sales/{sale_id}/delete"
)
async def delete_flash_sale(
    request: Request,
    sale_id: int,
):

    require_admin(request)

    with get_connection() as connection:

        connection.execute(
            """
            UPDATE flash_sale
            SET active_status='N'
            WHERE flash_sale_id=?
            """,
            (sale_id,),
        )

    return RedirectResponse(
        "/admin",
        status_code=303,
    )


# =========================================================
# UPDATE ORDER STATUS
# =========================================================

@router.post(
    "/orders/{order_no}/status"
)
async def update_order_status(
    request: Request,
    order_no: str,
    order_status: str = Form(...),
):

    require_admin(request)

    allowed = {
        "PENDING",
        "CONFIRMED",
        "PROCESSING",
        "SHIPPED",
        "DELIVERED",
        "CANCELLED",
    }

    if order_status not in allowed:
        raise HTTPException(
            status_code=400,
            detail="Invalid order status",
        )

    with get_connection() as connection:

        connection.execute(
            """
            UPDATE order_master
            SET order_status=?
            WHERE order_no=?
            """,
            (
                order_status,
                order_no,
            ),
        )

    return RedirectResponse(
        "/admin/orders",
        status_code=303,
    )

#with get_connection() as connection:
#    connection.execute("SELECT 1").fetchone()