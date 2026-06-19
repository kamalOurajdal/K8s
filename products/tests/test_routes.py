from app import create_app


def test_health():
    client = create_app().test_client()
    response = client.get("/health")

    assert response.status_code == 200
    assert response.get_json()["service"] == "products-service"


def test_list_products():
    client = create_app().test_client()
    response = client.get("/products")

    assert response.status_code == 200
    assert len(response.get_json()["data"]) == 3


def test_missing_product():
    client = create_app().test_client()
    response = client.get("/products/999")

    assert response.status_code == 404

