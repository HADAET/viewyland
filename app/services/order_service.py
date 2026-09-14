from datetime import datetime
import hashlib
import hmac
import os
from uuid import uuid4

from app.db.database import get_connection


class OrderError(Exception):
    """A business-rule error that can safely be returned to an API client."""


def _number(prefix: str) -> str:
    return f"{prefix}-{datetime.now():%Y%m%d}-{uuid4().hex[:8].upper()}"


def _hash_password(password: str) -> str:
    salt = os.urandom(16)
    digest = hashlib.pbkdf2_hmac("sha256", password.encode(), salt, 310_000)
    return f"{salt.hex()}${digest.hex()}"


def verify_password(password: str, password_hash: str | None) -> bool:
    if not password_hash or "$" not in password_hash:
        return False
    salt_hex, digest_hex = password_hash.split("$", 1)
    digest = hashlib.pbkdf2_hmac("sha256", password.encode(), bytes.fromhex(salt_hex), 310_000)
    return hmac.compare_digest(digest.hex(), digest_hex)


def register_customer(customer_name: str, mobile_no: str, email: str | None, address: str | None, password: str | None = None):
    with get_connection() as connection:
        customer = connection.execute("SELECT registration_no FROM bus_registration WHERE mobile_no = ?", (mobile_no.strip(),)).fetchone()
        if customer:
            raise OrderError("Already registered with this mobile number.")
        registration_no = _number("CUS")
        connection.execute("INSERT INTO bus_registration (registration_no, customer_name, mobile_no, email, present_address, password_hash) VALUES (?, ?, ?, ?, ?, ?)", (registration_no, customer_name.strip(), mobile_no.strip(), email, address, _hash_password(password) if password else None))
        return registration_no, True


def get_customer_by_mobile(mobile_no: str):
    with get_connection() as connection:
        customer = connection.execute("SELECT registration_no, customer_name, mobile_no, email, present_address, profile_image, password_hash, created_on FROM bus_registration WHERE mobile_no = ? AND active_status = 'Y'", (mobile_no.strip(),)).fetchone()
    return dict(customer) if customer else None


def get_customer_by_registration(registration_no: str):
    with get_connection() as connection:
        customer = connection.execute("SELECT registration_no, customer_name, mobile_no, email, present_address, profile_image, password_hash, created_on FROM bus_registration WHERE registration_no = ? AND active_status = 'Y'", (registration_no.strip(),)).fetchone()
    return dict(customer) if customer else None


def create_order(mobile_no: str, store_no: str, lines: list[dict], delivery_address: str | None = None):
    if not lines:
        raise OrderError("An order needs at least one item.")
    merged: dict[str, dict] = {}
    for line in lines:
        item_no = line["item_no"].strip().upper()
        if line["quantity"] <= 0 or line["discount_amount"] < 0:
            raise OrderError("Quantity must be positive and discount cannot be negative.")
        row = merged.setdefault(item_no, {"item_no": item_no, "quantity": 0, "discount_amount": 0})
        row["quantity"] += line["quantity"]
        row["discount_amount"] += line["discount_amount"]

    with get_connection() as connection:
        customer = connection.execute("SELECT registration_no, customer_name, mobile_no, present_address FROM bus_registration WHERE mobile_no = ? AND active_status = 'Y'", (mobile_no.strip(),)).fetchone()
        if not customer:
            raise OrderError("Please register with this mobile number before placing an order.")
        if not connection.execute("SELECT 1 FROM wms_store_mst WHERE wsm_store_no = ? AND active_status = 'Y'", (store_no,)).fetchone():
            raise OrderError("The selected fulfilment store is unavailable.")

        prepared = []
        for line in merged.values():
            product = connection.execute("""SELECT item.item_no, item.item_name, price.rate FROM bus_item_master item JOIN bus_price_list price ON price.item_no=item.item_no WHERE item.item_no=? AND item.active_status='Y' AND price.active_status='Y'""", (line["item_no"],)).fetchone()
            if not product:
                raise OrderError(f"Product {line['item_no']} is not available.")
            gross = product["rate"] * line["quantity"]
            if line["discount_amount"] > gross:
                raise OrderError(f"Discount for {product['item_name']} exceeds its line total.")
            prepared.append((product["item_no"], product["item_name"], line["quantity"], product["rate"], line["discount_amount"], gross - line["discount_amount"]))

        subtotal = sum(line[3] * line[2] for line in prepared)
        discount = sum(line[4] for line in prepared)
        order_no = _number("ORD")
        connection.execute("""INSERT INTO order_master (order_no, registration_no, wsm_store_no, subtotal, discount_amount, payable_amount, delivery_address, customer_name_snapshot, customer_mobile_snapshot) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)""", (order_no, customer["registration_no"], store_no, subtotal, discount, subtotal - discount, delivery_address or customer["present_address"], customer["customer_name"], customer["mobile_no"]))
        connection.executemany("""INSERT INTO order_details (order_no, item_no, item_name_snapshot, quantity, unit_price, discount_amount, line_total) VALUES (?, ?, ?, ?, ?, ?, ?)""", [(order_no, *line) for line in prepared])
    return get_order(order_no)


def confirm_order(order_no: str, payment_type: str, paid_amount: float):
    with get_connection() as connection:
        connection.execute("BEGIN IMMEDIATE")
        order = connection.execute("SELECT * FROM order_master WHERE order_no = ?", (order_no,)).fetchone()
        if not order:
            raise OrderError("Order not found.")
        if order["order_status"] != "PENDING":
            raise OrderError(f"Order {order_no} is already {order['order_status'].lower()}.")
        if round(paid_amount, 2) != round(order["payable_amount"], 2):
            raise OrderError("The payment amount must equal the order payable amount.")
        lines = connection.execute("SELECT * FROM order_details WHERE order_no = ?", (order_no,)).fetchall()
        for line in lines:
            stock = connection.execute("SELECT available_quantity FROM wms_item_stock WHERE item_no = ? AND wsm_store_no = ?", (line["item_no"], order["wsm_store_no"])).fetchone()
            if not stock or stock["available_quantity"] < line["quantity"]:
                raise OrderError(f"Insufficient stock for {line['item_name_snapshot']}.")

        invoice_no, receipt_no = _number("INV"), _number("MR")
        connection.execute("""INSERT INTO wms_sh_invheader (sh_invoice_no, order_no, sh_registration_no, sh_customer_name, sh_customer_contact, wsm_store_no, bill_amount, discount_amount, payable_amount) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)""", (invoice_no, order_no, order["registration_no"], order["customer_name_snapshot"], order["customer_mobile_snapshot"], order["wsm_store_no"], order["subtotal"], order["discount_amount"], order["payable_amount"]))
        connection.executemany("""INSERT INTO wms_sh_invline (sh_invoice_no, item_no, item_name_snapshot, sh_quantity, item_rate, discount, line_total) VALUES (?, ?, ?, ?, ?, ?, ?)""", [(invoice_no, line["item_no"], line["item_name_snapshot"], line["quantity"], line["unit_price"], line["discount_amount"], line["line_total"]) for line in lines])
        connection.execute("""INSERT INTO wms_sh_payment (sh_mr_no, sh_invoice_no, sh_payment_type, sh_payable_amt, sh_cashpaid_amt, payment_status) VALUES (?, ?, ?, ?, ?, 'PAID')""", (receipt_no, invoice_no, payment_type.upper(), order["payable_amount"], paid_amount))
        for line in lines:
            connection.execute("UPDATE wms_item_stock SET available_quantity=available_quantity-?, last_updated_on=CURRENT_TIMESTAMP WHERE item_no=? AND wsm_store_no=?", (line["quantity"], line["item_no"], order["wsm_store_no"]))
        connection.execute("UPDATE order_master SET order_status='CONFIRMED', payment_status='PAID', confirmed_on=CURRENT_TIMESTAMP WHERE order_no=?", (order_no,))
    return {**get_order(order_no), "invoice_no": invoice_no, "receipt_no": receipt_no}


def get_order(order_no: str):
    with get_connection() as connection:
        order = connection.execute("SELECT * FROM order_master WHERE order_no = ?", (order_no,)).fetchone()
        if not order:
            raise OrderError("Order not found.")
        lines = connection.execute("SELECT item_no, item_name_snapshot, quantity, unit_price, discount_amount, line_total FROM order_details WHERE order_no = ?", (order_no,)).fetchall()
    return {"order_no": order["order_no"], "status": order["order_status"], "payment_status": order["payment_status"], "payable_amount": order["payable_amount"], "store_no": order["wsm_store_no"], "lines": [dict(line) for line in lines]}
