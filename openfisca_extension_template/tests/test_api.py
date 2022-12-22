"""Smoke-test to ensure the API runs and returns a valid response."""

from subprocess import SubprocessError, TimeoutExpired
from urllib import request
import json
import random
import subprocess

import pytest


@pytest.fixture
def host():
    return "127.0.0.1"


@pytest.fixture
def port():
    return random.randint(5000, 5999)


@pytest.fixture
def endpoint():
    return "spec"


@pytest.fixture
def payload(host, port, endpoint):
    return {
        "url": f"http://{host}:{port}/{endpoint}",
        "timeout": 1,
        }


@pytest.fixture
def pipe():
    return subprocess.PIPE


@pytest.fixture
def server(host, port, pipe):
    cmd = [
        "openfisca",
        "serve",
        "--country-package",
        "openfisca_country_template",
        "--extensions",
        "openfisca_extension_template",
        "--port",
        str(port),
        ]

    proc = subprocess.Popen(cmd, stdout = pipe, stderr = pipe)

    try:
        _, out = proc.communicate(timeout = 1)

    except TimeoutExpired as error:
        out = error.stderr

    if f"Listening at: http://{host}:{port} ({proc.pid})" in str(out):
        yield
        proc.terminate()

    else:
        proc.terminate()
        raise SubprocessError(f"Server did not start!\n{out.decode('utf-8')}")


def test_openfisca_server(server, payload):
    with request.urlopen(**payload) as response:
        data = json.loads(response.read().decode("utf-8"))
        assert data["info"]["title"] == "Openfisca-Country-Template Web API"
