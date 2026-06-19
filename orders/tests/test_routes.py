import responses

from app import create_app
from app.store import ORDERS


def setup_function():
    ORDERS[:] = [
        {"id": 1, "user_id": 1, "product_id": 1, "quantity": 1, "status": "created"},
    ]


def test_health():
    client = create_app().test_client()
    response = client.get("/health")

    assert response.status_code == 200
    assert response.get_json()["service"] == "orders-service"


def test_list_orders():
    client = create_app().test_client()
    response = client.get("/orders")

    assert response.status_code == 200
    assert len(response.get_json()["data"]) == 1


@responses.activate
def test_create_order():
    responses.get(
        "http://localhost:5001/users/1",
        json={"data": {"id": 1, "name": "Amina", "email": "amina@example.com"}},
        status=200,
    )
    responses.get(
        "http://localhost:5002/products/1",
        json={"data": {"id": 1, "name": "Keyboard", "price": 49.99, "stock": 10}},
        status=200,
    )

    client = create_app().test_client()
    response = client.post(
        "/orders",
        json={"user_id": 1, "product_id": 1, "quantity": 2},
    )

    assert response.status_code == 201
    body = response.get_json()["data"]
    assert body["quantity"] == 2
    assert body["user"]["name"] == "Amina"
    assert body["product"]["name"] == "Keyboard"


def test_invalid_order_payload():
    client = create_app().test_client()
    response = client.post("/orders", json={"user_id": "1", "product_id": 1})

    assert response.status_code == 400
