import json

from app.services.product_service import get_product


COOKIE_NAME = "viewyland_cart"


def read_cart(raw_cookie: str | None) -> dict[str, int]:
	if not raw_cookie:
		return {}
	try:
		data = json.loads(raw_cookie)
	except (TypeError, ValueError):
		return {}
	if not isinstance(data, dict):
		return {}
	return {str(item_no): max(1, int(quantity)) for item_no, quantity in data.items() if str(item_no)}


def cart_count(raw_cookie: str | None) -> int:
	return sum(read_cart(raw_cookie).values())


#def cart_lines(raw_cookie: str | None) -> list[dict]:
#	lines = []
#	for item_no, quantity in read_cart(raw_cookie).items():
#		product = get_product(item_no)
#		if product:
#			lines.append({"product": product, "quantity": quantity, "total": product["price"] * quantity})
#	return lines

def cart_lines(raw_cookie: str | None) -> list[dict]:
    lines = []
    for item_no, quantity in read_cart(raw_cookie).items(): #[cite: 1]
        product = get_product(item_no) #[cite: 1]
        if product:
            lines.append({
                "product": product,  # products.py এর পুরো product dict টি পাস হচ্ছে
                "quantity": quantity, 
                "total": product["price"] * quantity
            }) #[cite: 1]
    return lines

def add_to_cart(raw_cookie: str | None, item_no: str) -> tuple[str, int]:
	cart = read_cart(raw_cookie)
	product = get_product(item_no)
	if not product:
		raise ValueError("Product not found")
	cart[product["id"]] = cart.get(product["id"], 0) + 1
	return json.dumps(cart), sum(cart.values())


def update_cart(raw_cookie: str | None, item_no: str, quantity: int) -> tuple[str, int]:
	cart = read_cart(raw_cookie)
	item_key = item_no.strip().upper()
	if item_key not in cart:
		raise ValueError("Product is not in the cart")
	if quantity <= 0:
		cart.pop(item_key)
	else:
		cart[item_key] = min(quantity, 99)
	return json.dumps(cart), sum(cart.values())
