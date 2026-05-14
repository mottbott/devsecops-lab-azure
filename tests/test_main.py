from fastapi.testclient import TestClient

from app.main import app

client = TestClient(app)


def test_hello_returns_greeting() -> None:
    response = client.get("/hello")
    assert response.status_code == 200
    assert response.json() == {"message": "Hello from DevSecOps Lab"}


def test_healthz_returns_ok() -> None:
    response = client.get("/healthz")
    assert response.status_code == 200
    assert response.json() == {"status": "ok"}
