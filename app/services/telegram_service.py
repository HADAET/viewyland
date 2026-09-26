import os
import time
from datetime import datetime

import requests

from app.db.database import get_connection


TELEGRAM_BOT_TOKEN = os.environ["TELEGRAM_BOT_TOKEN"]
DEFAULT_CHAT_ID = os.environ["TELEGRAM_CHAT_ID"]

TELEGRAM_URL = (
    f"https://api.telegram.org/bot{TELEGRAM_BOT_TOKEN}/sendMessage"
)


def _post_with_retry(payload, retries=3, delay=2):
    last_error = None

    for attempt in range(1, retries + 1):
        try:
            response = requests.post(
                TELEGRAM_URL,
                json=payload,
                timeout=10
            )

            response.raise_for_status()
            return response.json()

        except Exception as e:
            last_error = e
            print(f"Telegram attempt {attempt} failed: {e}")

            if attempt < retries:
                time.sleep(delay)

    return {
        "status": "failed",
        "error": str(last_error)
    }


def send_order_confirmation(order_id, chat_id=None):
    chat_id = chat_id or DEFAULT_CHAT_ID

    with get_connection() as connection:
        cursor = connection.cursor()

        cursor.execute("""
            SELECT
                om.created_on,
                od.item_name_snapshot,
                od.quantity,
                od.unit_price,
                od.line_total
            FROM order_details od
            JOIN order_master om
                ON od.order_no = om.order_no
            WHERE od.order_no = ?
        """, (order_id,))

        items = cursor.fetchall()

    if not items:
        return {
            "status": "error",
            "message": f"No items found for Order {order_id}"
        }

    raw_created_on = items[0][0]

    try:
        order_date = datetime.fromisoformat(
            str(raw_created_on)
        ).strftime("%d %b %Y")
    except (TypeError, ValueError):
        order_date = str(raw_created_on).split(" ")[0]

    item_lines = [
        f"  • *{item_name_snapshot}* x {quantity} = ৳ {line_total:.2f}"
        for created_on, item_name_snapshot, quantity, unit_price, line_total
        in items
    ]

    items_text = "\n".join(item_lines)

    total_amount = sum(item[4] for item in items)

    message_text = (
        f"🛍️ *নতুন অর্ডার এসেছে! Date: {order_date}*\n\n"
        f"🆔 *অর্ডার আইডি:* {order_id}\n"
        f"📦 *আইটেম সমুহ:*\n{items_text}\n\n"
        f"💰 *মোট টাকা:* ৳ {total_amount:.2f}\n\n"
        f"⚡ _অনুগ্রহ করে ড্যাশবোর্ড চেক করুন।_"
    )

    payload = {
        "chat_id": chat_id,
        "text": message_text,
        "parse_mode": "Markdown"
    }

    return _post_with_retry(payload)
