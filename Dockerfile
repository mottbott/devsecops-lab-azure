# syntax=docker/dockerfile:1.7

# ---- Stage 1: builder ----------------------------------------------------
FROM python:3.14-slim AS builder

WORKDIR /build

RUN pip install --no-cache-dir --upgrade pip wheel

COPY pyproject.toml ./
COPY app ./app

RUN pip wheel --no-cache-dir --wheel-dir /wheels .

# ---- Stage 2: runtime ----------------------------------------------------
FROM python:3.14-slim AS runtime

RUN groupadd --system --gid 1001 app && \
    useradd  --system --uid 1001 --gid app --shell /usr/sbin/nologin app

WORKDIR /app

COPY --from=builder /wheels /tmp/wheels
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir --no-index --find-links /tmp/wheels devsecops-lab && \
    rm -rf /tmp/wheels /root/.cache

USER app

EXPOSE 8000

CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]
