ORDERS = [
    {"id": 1, "user_id": 1, "product_id": 1, "quantity": 1, "status": "created"},
    {"id": 2, "user_id": 2, "product_id": 2, "quantity": 2, "status": "created"},
    {"id": 3, "user_id": 3, "product_id": 3, "quantity": 3, "status": "created"},
    {"id": 4, "user_id": 4, "product_id": 4, "quantity": 4, "status": "created"},
]


def list_orders():
    return ORDERS


def create_order(user_id, product_id, quantity):
    order = {
        "id": len(ORDERS) + 1,
        "user_id": user_id,
        "product_id": product_id,
        "quantity": quantity,
        "status": "created",
    }
    ORDERS.append(order)
    return order

