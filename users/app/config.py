import os


class Config:
    SERVICE_NAME = os.getenv("SERVICE_NAME", "users-service")

