import sqlite3
from pathlib import Path



DATABASE_PATH = Path(__file__).resolve().parents[2] / "ecommerce.db"


def get_connection():
    connection = sqlite3.connect(DATABASE_PATH, timeout=30.0)
    connection.row_factory = sqlite3.Row
    connection.execute("PRAGMA foreign_keys = ON")
    # WAL mode permits your web users to read data even if SQLite Browser holds a brief write lock
    connection.execute("PRAGMA journal_mode = WAL;")
    connection.execute("PRAGMA synchronous = NORMAL;")
    return connection


def initialize_database():
    with get_connection() as connection:
        # SQLite equivalent of the product and price tables in onlineshop_db.sql.
        connection.executescript(
            """
            CREATE TABLE IF NOT EXISTS bus_item_master (
                item_no TEXT PRIMARY KEY,
                item_type TEXT,
                item_category TEXT NOT NULL,
                item_name TEXT NOT NULL,
                item_description TEXT,
                made_in TEXT,
                active_status TEXT NOT NULL DEFAULT 'Y',
                display_tone TEXT NOT NULL DEFAULT 'sand',
                display_type TEXT NOT NULL DEFAULT 'vase',
                product_tag TEXT
            );

            CREATE TABLE IF NOT EXISTS bus_item_category (
                category_id INTEGER PRIMARY KEY AUTOINCREMENT,
                category_name TEXT NOT NULL UNIQUE,
                description TEXT,
                active_status TEXT NOT NULL DEFAULT 'Y'
            );

            CREATE TABLE IF NOT EXISTS bus_price_list (
                price_line_no INTEGER PRIMARY KEY AUTOINCREMENT,
                item_no TEXT NOT NULL UNIQUE,
                rate REAL NOT NULL,
                currency TEXT NOT NULL DEFAULT 'TK.',
                active_status TEXT NOT NULL DEFAULT 'Y',
                FOREIGN KEY (item_no) REFERENCES bus_item_master(item_no)
            );

            CREATE TABLE IF NOT EXISTS item_image (
                image_id INTEGER PRIMARY KEY AUTOINCREMENT,
                item_no TEXT NOT NULL,
                image_url TEXT NOT NULL,
                alt_text TEXT,
                display_order INTEGER NOT NULL DEFAULT 1,
                active_status TEXT NOT NULL DEFAULT 'Y',
                created_on TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
                FOREIGN KEY (item_no) REFERENCES bus_item_master(item_no)
            );

            CREATE TABLE IF NOT EXISTS flash_sale (
                flash_sale_id INTEGER PRIMARY KEY AUTOINCREMENT,
                item_no TEXT NOT NULL,
                sale_price REAL,
                currency TEXT,
                starts_on TEXT NOT NULL,
                ends_on TEXT NOT NULL,
                active_status TEXT NOT NULL DEFAULT 'Y',
                FOREIGN KEY (item_no) REFERENCES bus_item_master(item_no)
            );

            CREATE TABLE IF NOT EXISTS wms_store_mst (
                wsm_store_no TEXT PRIMARY KEY,
                wsm_store_name TEXT NOT NULL,
                wsm_address TEXT,
                active_status TEXT NOT NULL DEFAULT 'Y'
            );

            CREATE TABLE IF NOT EXISTS wms_item_stock (
                item_no TEXT NOT NULL,
                wsm_store_no TEXT NOT NULL,
                available_quantity INTEGER NOT NULL DEFAULT 0 CHECK (available_quantity >= 0),
                reserved_quantity INTEGER NOT NULL DEFAULT 0 CHECK (reserved_quantity >= 0),
                last_updated_on TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
                PRIMARY KEY (item_no, wsm_store_no),
                FOREIGN KEY (item_no) REFERENCES bus_item_master(item_no),
                FOREIGN KEY (wsm_store_no) REFERENCES wms_store_mst(wsm_store_no)
            );

            CREATE TABLE IF NOT EXISTS bus_registration (
                registration_no TEXT PRIMARY KEY,
                customer_name TEXT NOT NULL,
                mobile_no TEXT NOT NULL UNIQUE,
                email TEXT,
                present_address TEXT,
                password_hash TEXT,
                profile_image TEXT,
                active_status TEXT NOT NULL DEFAULT 'Y',
                created_on TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
                updated_on TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
            );

            CREATE TABLE IF NOT EXISTS order_master (
                order_no TEXT PRIMARY KEY,
                registration_no TEXT NOT NULL,
                wsm_store_no TEXT NOT NULL,
                order_status TEXT NOT NULL DEFAULT 'PENDING',
                payment_status TEXT NOT NULL DEFAULT 'UNPAID',
                subtotal REAL NOT NULL DEFAULT 0,
                discount_amount REAL NOT NULL DEFAULT 0,
                payable_amount REAL NOT NULL DEFAULT 0,
                delivery_address TEXT,
                customer_name_snapshot TEXT NOT NULL,
                customer_mobile_snapshot TEXT NOT NULL,
                created_on TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
                confirmed_on TEXT,
                FOREIGN KEY (registration_no) REFERENCES bus_registration(registration_no),
                FOREIGN KEY (wsm_store_no) REFERENCES wms_store_mst(wsm_store_no)
            );

            CREATE TABLE IF NOT EXISTS order_details (
                order_line_no INTEGER PRIMARY KEY AUTOINCREMENT,
                order_no TEXT NOT NULL,
                item_no TEXT NOT NULL,
                item_name_snapshot TEXT NOT NULL,
                quantity INTEGER NOT NULL CHECK (quantity > 0),
                unit_price REAL NOT NULL CHECK (unit_price >= 0),
                discount_amount REAL NOT NULL DEFAULT 0 CHECK (discount_amount >= 0),
                line_total REAL NOT NULL CHECK (line_total >= 0),
                FOREIGN KEY (order_no) REFERENCES order_master(order_no),
                FOREIGN KEY (item_no) REFERENCES bus_item_master(item_no)
            );

            CREATE TABLE IF NOT EXISTS wms_sh_invheader (
                sh_invoice_no TEXT PRIMARY KEY,
                order_no TEXT NOT NULL UNIQUE,
                sh_invoice_date TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
                sh_registration_no TEXT NOT NULL,
                sh_customer_name TEXT NOT NULL,
                sh_customer_contact TEXT NOT NULL,
                sh_invoice_status TEXT NOT NULL DEFAULT 'CONFIRMED',
                wsm_store_no TEXT NOT NULL,
                bill_amount REAL NOT NULL,
                discount_amount REAL NOT NULL DEFAULT 0,
                payable_amount REAL NOT NULL,
                FOREIGN KEY (order_no) REFERENCES order_master(order_no)
            );

            CREATE TABLE IF NOT EXISTS wms_sh_invline (
                sh_invline_no INTEGER PRIMARY KEY AUTOINCREMENT,
                sh_invoice_no TEXT NOT NULL,
                item_no TEXT NOT NULL,
                item_name_snapshot TEXT NOT NULL,
                sh_quantity INTEGER NOT NULL,
                item_rate REAL NOT NULL,
                discount REAL NOT NULL DEFAULT 0,
                line_total REAL NOT NULL,
                FOREIGN KEY (sh_invoice_no) REFERENCES wms_sh_invheader(sh_invoice_no),
                FOREIGN KEY (item_no) REFERENCES bus_item_master(item_no)
            );

            CREATE TABLE IF NOT EXISTS wms_sh_payment (
                sh_mr_no TEXT PRIMARY KEY,
                sh_invoice_no TEXT NOT NULL,
                sh_payment_date TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
                sh_payment_type TEXT NOT NULL,
                sh_payable_amt REAL NOT NULL,
                sh_cashpaid_amt REAL NOT NULL DEFAULT 0,
                payment_status TEXT NOT NULL DEFAULT 'PENDING',
                FOREIGN KEY (sh_invoice_no) REFERENCES wms_sh_invheader(sh_invoice_no)
            );
            """
        )

        price_columns = {row[1] for row in connection.execute("PRAGMA table_info(bus_price_list)").fetchall()}
        if "previous_price" not in price_columns:
            connection.execute("ALTER TABLE bus_price_list ADD COLUMN previous_price REAL")
        if "currency" not in price_columns:
            connection.execute("ALTER TABLE bus_price_list ADD COLUMN currency TEXT NOT NULL DEFAULT 'TK.'")

        registration_columns = {row[1] for row in connection.execute("PRAGMA table_info(bus_registration)").fetchall()}
        if "password_hash" not in registration_columns:
            connection.execute("ALTER TABLE bus_registration ADD COLUMN password_hash TEXT")
        if "profile_image" not in registration_columns:
            connection.execute("ALTER TABLE bus_registration ADD COLUMN profile_image TEXT")
        if "updated_on" not in registration_columns:
            connection.execute("ALTER TABLE bus_registration ADD COLUMN updated_on TEXT")

        category_count = connection.execute("SELECT COUNT(*) FROM bus_item_category").fetchone()[0]
        if category_count == 0:
            connection.executemany(
                "INSERT INTO bus_item_category (category_name, description) VALUES (?, ?)",
                [
                    ("Vintage clocks", "Timepieces with a story to tell."),
                    ("Showpiece decor", "Objects made to start a conversation."),
                    ("Table lamps", "A warmer kind of illumination."),
                    ("Wall & mirrors", "Details that complete the room."),
                ],
            )
        # Backfill any category already used on an item but missing from the lookup table.
        connection.execute(
            """INSERT OR IGNORE INTO bus_item_category (category_name)
            SELECT DISTINCT item_category FROM bus_item_master
            WHERE item_category NOT IN (SELECT category_name FROM bus_item_category)"""
        )

        item_count = connection.execute("SELECT COUNT(*) FROM bus_item_master").fetchone()[0]
        if item_count == 0:
            connection.executemany(
                """INSERT INTO bus_item_master
                (item_no, item_type, item_category, item_name, item_description, made_in,
                 display_tone, display_type, product_tag)
                VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)""",
                [
                    ("VL-001", "Clock", "Vintage clocks", "Brixton mantel clock", "Warm timber mantel clock with a classic Roman numeral dial.", "Malaysia", "terracotta", "clock", "Showpiece"),
                    ("VL-002", "Globe", "Showpiece decor", "Montrose globe bar", "A statement globe inspired by old-world exploration.", "Malaysia", "sand", "globe", "New arrival"),
                    ("VL-003", "Telephone", "Showpiece decor", "Hawthorn rotary phone", "A tactile retro telephone for shelves and sideboards.", "Malaysia", "lilac", "phone", "Limited"),
                    ("VL-004", "Radio", "Showpiece decor", "Tivoli transistor radio", "A nostalgic radio object with a warm walnut finish.", "Malaysia", "olive", "radio", None),
                    ("VL-005", "Clock", "Vintage clocks", "Windsor wall clock", "Oversized wall clock with an aged brass-inspired frame.", "Malaysia", "sand", "clock", "New arrival"),
                    ("VL-006", "Lamp", "Table lamps", "Marcel pleated lamp", "A softly lit accent for a reading nook or console.", "Malaysia", "terracotta", "lamp", None),
                    ("VL-007", "Mirror", "Wall & mirrors", "Orla oval mirror", "A refined oval mirror designed to soften a wall.", "Malaysia", "lilac", "mirror", "Showpiece"),
                    ("VL-008", "Vase", "Showpiece decor", "Pienza ceramic vessel", "An earthy ceramic vessel with sculptural presence.", "Malaysia", "olive", "vase", None),
                ],
            )
            connection.executemany(
                "INSERT INTO bus_price_list (item_no, rate) VALUES (?, ?)",
                [("VL-001", 289), ("VL-002", 459), ("VL-003", 198), ("VL-004", 169), ("VL-005", 245), ("VL-006", 139), ("VL-007", 319), ("VL-008", 119)],
            )

        connection.execute(
            """INSERT OR IGNORE INTO wms_store_mst (wsm_store_no, wsm_store_name, wsm_address)
            VALUES ('VL-MAIN', 'Viewyland Main Store', 'Kuala Lumpur, Malaysia')"""
        )
        connection.execute(
            """INSERT OR IGNORE INTO wms_item_stock (item_no, wsm_store_no, available_quantity)
            SELECT item_no, 'VL-MAIN', 5 FROM bus_item_master WHERE active_status = 'Y'"""
        )
