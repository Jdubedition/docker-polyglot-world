from socket import gethostname
from fastapi import FastAPI

app = FastAPI()


@app.get("/")
def read_root():
    return {"hello": "World", "from": gethostname()}
