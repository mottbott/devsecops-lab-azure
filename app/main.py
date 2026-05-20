import os

from azure.core.exceptions import AzureError
from azure.identity import DefaultAzureCredential
from azure.keyvault.secrets import SecretClient
from fastapi import FastAPI, HTTPException

app = FastAPI(title="DevSecOps Lab Hello", version="0.1.0")

DEMO_SECRET_NAME = "demo-message"


@app.get("/hello")
def hello() -> dict[str, str]:
    return {"message": "Hello from DevSecOps Lab"}


@app.get("/healthz")
def healthz() -> dict[str, str]:
    return {"status": "ok"}


@app.get("/config")
def config() -> dict[str, str]:
    """Read a demo secret from Key Vault using the App Service managed identity.

    No secret value lives in code or app settings — only the vault URI. The
    SecretClient is built per request for demo clarity; in a hot path you would
    cache the client and credential.
    """
    vault_uri = os.environ.get("KEY_VAULT_URI")
    if not vault_uri:
        raise HTTPException(status_code=500, detail="KEY_VAULT_URI not configured")

    try:
        client = SecretClient(
            vault_url=vault_uri,
            credential=DefaultAzureCredential(),
        )
        secret = client.get_secret(DEMO_SECRET_NAME)
    except AzureError as exc:
        raise HTTPException(
            status_code=502,
            detail=f"Key Vault access failed: {exc.__class__.__name__}",
        ) from exc

    return {"demo_message": secret.value}


@app.get("/config-ref")
def config_ref() -> dict[str, str]:
    """Read the same secret, but via an App Service Key Vault Reference.

    The value is injected as a plain env var — App Service resolved the
    @Microsoft.KeyVault(...) reference server-side using the App Service
    managed identity. No SDK, no credential, no KV call in app code. This is
    the App Service analogue to the AKS Secrets Store CSI driver file-mount.
    """
    value = os.environ.get("DEMO_MESSAGE_VIA_REF")
    if not value:
        raise HTTPException(
            status_code=500,
            detail="DEMO_MESSAGE_VIA_REF not set (KV reference unresolved?)",
        )
    return {"demo_message": value}
