from flask import Blueprint, current_app, jsonify

from .data import get_user, list_users

bp = Blueprint("users", __name__)


@bp.get("/health")
def health():
    return jsonify({"status": "ok", "service": current_app.config["SERVICE_NAME"]})


@bp.get("/users")
def users():
    return jsonify({"data": list_users()})


@bp.get("/users/<int:user_id>")
def user_detail(user_id):
    user = get_user(user_id)
    if user is None:
        return jsonify({"error": "user not found"}), 404
    return jsonify({"data": user})

