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


def test_homepage_with_debug_on(client):
    app.debug = True
    response = client.get("/")
    assert response.status_code == 200
    assert response.json() == {"hello": "World", "from": gethostname()}
    app.debug = False


def test_homepage_path(client):
    response = client.get("/path")
    assert response.status_code == 404
    assert response.text == "Not Found"


def test_homepage_mock_gethostname(client, mocker):
    mocker.patch("main.gethostname", return_value="test-host")
    response = client.get("/")
    assert response.status_code == 200
    assert response.json() == {"hello": "World", "from": "test-host"}


def test_homepage_500_error(client, mocker):
    mocker.patch("main.gethostname", side_effect=Exception)
    response = client.get("/")
    assert response.status_code == 500
