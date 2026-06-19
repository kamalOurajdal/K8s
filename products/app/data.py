PRODUCTS = [
    {"id": 1, "name": "Keyboard", "price": 49.99, "stock": 10},
    {"id": 2, "name": "Mouse", "price": 24.99, "stock": 25},
    {"id": 3, "name": "Monitor", "price": 189.99, "stock": 7},
    {"id": 4, "name": "Printer", "price": 129.99, "stock": 15},
]


def list_products():
    return PRODUCTS


def get_product(product_id):
    return next((product for product in PRODUCTS if product["id"] == product_id), None)

