import pytest
from socket import gethostname
from starlette.testclient import TestClient

from main import app


@pytest.fixture
def client():
    return TestClient(app)


def test_homepage(client):
    response = client.get("/")
    assert response.status_code == 200
    assert response.json() == {"hello": "World", "from": gethostname()}


def test_homepage_with_debug_off(client):
    app.debug = False
    response = client.get("/")
    assert response.status_code == 200
    assert response.json() == {"hello": "World", "from": gethostname()}
    app.debug = True
