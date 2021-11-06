# build stage
FROM python:3.9-alpine3.14 AS build
RUN python -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

COPY ./requirements.txt /app/
WORKDIR /app
RUN pip install --no-cache-dir --upgrade -r /app/requirements.txt

# run stage
FROM python:3.9-alpine3.14 AS run
COPY --from=build /opt/venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"
COPY ./main.py /app/

CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "80", "--reload"]
