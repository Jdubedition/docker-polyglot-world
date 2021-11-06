from socket import gethostname
from fastapi import FastAPI

app = FastAPI()


@app.get("/")
def read_root():
    return {"Hello": "World", "From": gethostname()}
