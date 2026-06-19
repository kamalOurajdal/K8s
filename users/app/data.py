USERS = [
    {"id": 1, "name": "Amina", "email": "amina@example.com"},
    {"id": 2, "name": "Youssef", "email": "youssef@example.com"},
    {"id": 3, "name": "Nora", "email": "nora@example.com"},
    {"id": 4, "name": "Omar", "email": "omar@example.com"},
]


def list_users():
    return USERS


def get_user(user_id):
    return next((user for user in USERS if user["id"] == user_id), None)

