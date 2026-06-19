import os


class Config:
    SERVICE_NAME = os.getenv("SERVICE_NAME", "orders-service")
    USERS_SERVICE_URL = os.getenv("USERS_SERVICE_URL", "http://localhost:5001")
    PRODUCTS_SERVICE_URL = os.getenv("PRODUCTS_SERVICE_URL", "http://localhost:5002")
    REQUEST_TIMEOUT_SECONDS = float(os.getenv("REQUEST_TIMEOUT_SECONDS", "2"))

