# build stage
FROM python:3.11.0-alpine3.16 AS build
RUN python -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

COPY python/requirements.txt /app/
WORKDIR /app
RUN pip install --no-cache-dir --upgrade -r /app/requirements.txt

# run stage
FROM python:3.11.0-alpine3.16 AS run
COPY --from=build /opt/venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"
COPY python/main.py /app/
# setup the same structure as in the source repo
COPY ../hello-world.json /

CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8080"]
