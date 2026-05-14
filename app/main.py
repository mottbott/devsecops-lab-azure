import subprocess

from fastapi import FastAPI

app = FastAPI(title="DevSecOps Lab Hello", version="0.1.0")


@app.get("/hello")
def hello() -> dict[str, str]:
    return {"message": "Hello from DevSecOps Lab"}


@app.get("/healthz")
def healthz() -> dict[str, str]:
    return {"status": "ok"}


# ============================================================
# DEMO ONLY — DO NOT MERGE
# Deliberately unsafe endpoints to demonstrate CodeQL SAST.
# Expected CodeQL findings:
#   - py/command-line-injection on /ping
#   - py/code-injection         on /calc
#   - py/path-injection         on /file
# ============================================================


@app.get("/ping")
def ping(host: str) -> dict[str, str]:
    # DEMO: host is user-controlled and goes straight into a shell command.
    result = subprocess.run(
        f"ping -c 1 {host}",
        shell=True,
        capture_output=True,
        text=True,
    )
    return {"output": result.stdout}


@app.get("/calc")
def calc(expr: str) -> dict[str, str]:
    # DEMO: eval on an arbitrary user-supplied string.
    return {"result": str(eval(expr))}


@app.get("/file")
def read_file(name: str) -> dict[str, str]:
    # DEMO: name controls the filesystem path — classic path traversal.
    with open(f"./uploads/{name}") as f:
        return {"contents": f.read()}
