from flask import Blueprint, current_app, jsonify

from .data import get_product, list_products

bp = Blueprint("products", __name__)


@bp.get("/health")
def health():
    return jsonify({"status": "ok", "service": current_app.config["SERVICE_NAME"]})


@bp.get("/products")
def products():
    return jsonify({"data": list_products()})


@bp.get("/products/<int:product_id>")
def product_detail(product_id):
    product = get_product(product_id)
    if product is None:
        return jsonify({"error": "product not found"}), 404
    return jsonify({"data": product})

