from app import create_app


def test_health():
    client = create_app().test_client()
    response = client.get("/health")

    assert response.status_code == 200
    assert response.get_json()["service"] == "users-service"


def test_list_users():
    client = create_app().test_client()
    response = client.get("/users")

    assert response.status_code == 200
    assert len(response.get_json()["data"]) == 3


def test_missing_user():
    client = create_app().test_client()
    response = client.get("/users/999")

    assert response.status_code == 404

