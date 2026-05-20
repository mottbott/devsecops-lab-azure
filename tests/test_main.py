import pytest
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


class _FakeSecret:
    value = "Hello from Key Vault"


class _FakeSecretClient:
    def __init__(self, *args, **kwargs) -> None:
        pass

    def get_secret(self, name: str) -> _FakeSecret:
        assert name == "demo-message"
        return _FakeSecret()


def test_config_returns_secret(monkeypatch: pytest.MonkeyPatch) -> None:
    # No real Azure: stub the Key Vault SDK + credential, set the vault URI.
    monkeypatch.setenv("KEY_VAULT_URI", "https://example.vault.azure.net/")
    monkeypatch.setattr("app.main.SecretClient", _FakeSecretClient)
    monkeypatch.setattr("app.main.DefaultAzureCredential", lambda *a, **k: object())

    response = client.get("/config")
    assert response.status_code == 200
    assert response.json() == {"demo_message": "Hello from Key Vault"}


def test_config_without_vault_uri_is_500(monkeypatch: pytest.MonkeyPatch) -> None:
    monkeypatch.delenv("KEY_VAULT_URI", raising=False)

    response = client.get("/config")
    assert response.status_code == 500


def test_config_ref_returns_injected_value(monkeypatch: pytest.MonkeyPatch) -> None:
    # App Service would inject the resolved secret value as this env var.
    monkeypatch.setenv("DEMO_MESSAGE_VIA_REF", "Hello from Key Vault")

    response = client.get("/config-ref")
    assert response.status_code == 200
    assert response.json() == {"demo_message": "Hello from Key Vault"}


def test_config_ref_without_env_is_500(monkeypatch: pytest.MonkeyPatch) -> None:
    monkeypatch.delenv("DEMO_MESSAGE_VIA_REF", raising=False)

    response = client.get("/config-ref")
    assert response.status_code == 500
