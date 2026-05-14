from fastapi import FastAPI

app = FastAPI(title="DevSecOps Lab Hello", version="0.1.0")


@app.get("/hello")
def hello() -> dict[str, str]:
    return {"message": "Hello from DevSecOps Lab"}


@app.get("/healthz")
def healthz() -> dict[str, str]:
    return {"status": "ok"}
