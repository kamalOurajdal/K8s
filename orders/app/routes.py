from flask import Blueprint, current_app, jsonify, request
from requests import RequestException

from .clients import ServiceClient
from .store import create_order, list_orders

bp = Blueprint("orders", __name__)


@bp.get("/health")
def health():
    return jsonify({"status": "ok", "service": current_app.config["SERVICE_NAME"]})


@bp.get("/orders")
def orders():
    return jsonify({"data": list_orders()})


@bp.post("/orders")
def create_order_route():
    payload = request.get_json(silent=True) or {}
    user_id = payload.get("user_id")
    product_id = payload.get("product_id")
    quantity = payload.get("quantity", 1)

    if not isinstance(user_id, int) or not isinstance(product_id, int):
        return jsonify({"error": "user_id and product_id must be integers"}), 400

    if not isinstance(quantity, int) or quantity < 1:
        return jsonify({"error": "quantity must be a positive integer"}), 400

    timeout = current_app.config["REQUEST_TIMEOUT_SECONDS"]
    users = ServiceClient(current_app.config["USERS_SERVICE_URL"], timeout)
    products = ServiceClient(current_app.config["PRODUCTS_SERVICE_URL"], timeout)

    try:
        user = users.get(f"/users/{user_id}")
        product = products.get(f"/products/{product_id}")
    except RequestException:
        return jsonify({"error": "dependency service unavailable"}), 503

    if user is None:
        return jsonify({"error": "user not found"}), 404

    if product is None:
        return jsonify({"error": "product not found"}), 404

    order = create_order(user_id=user_id, product_id=product_id, quantity=quantity)
    return jsonify({"data": {**order, "user": user, "product": product}}), 201
