# Flask Microservices Test Project

This repository contains three small Flask microservices that model a simple shop workflow:

- `users-service`: manages demo users
- `products-service`: manages demo products
- `orders-service`: creates demo orders and calls the users/products services

The services are intentionally simple, but structured like real deployable services with app factories, health checks, tests, Dockerfiles, Docker Compose, and Kubernetes manifests.

## Project Layout

```text
.
├── docker-compose.yml
├── k8s/
│   ├── namespace.yaml
│   ├── users-service.yaml
│   ├── products-service.yaml
│   └── orders-service.yaml
└── services/
    ├── users/
    ├── products/
    └── orders/
```

## Run Locally With Docker Compose

```bash
docker compose up --build
```

Services:

- Users: http://localhost:5001
- Products: http://localhost:5002
- Orders: http://localhost:5003

## Example Requests

```bash
curl http://localhost:5001/health
curl http://localhost:5001/users

curl http://localhost:5002/health
curl http://localhost:5002/products

curl http://localhost:5003/health
curl http://localhost:5003/orders
curl -X POST http://localhost:5003/orders \
  -H 'Content-Type: application/json' \
  -d '{"user_id": 1, "product_id": 1, "quantity": 2}'
```

## Run One Service Without Docker

```bash
cd services/users
python -m venv .venv
. .venv/bin/activate
pip install -r requirements-dev.txt
flask --app app:create_app run --port 5001
```

Use the same pattern for `products` and `orders`, changing the port.

## Run Tests

From each service directory:

```bash
pip install -r requirements-dev.txt
pytest
```

## Kubernetes

Build and push images with names that match the manifests, or update the `image` fields first.

```bash
kubectl apply -f k8s/namespace.yaml
kubectl apply -f k8s/
```

