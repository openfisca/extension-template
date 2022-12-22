"""Smoke-test to ensure the API runs and returns a valid response."""

from subprocess import SubprocessError, TimeoutExpired
from urllib import request
import json
import random
import subprocess

import pytest


@pytest.fixture
def host():
    """Return the host to use for the API."""

    return "127.0.0.1"


@pytest.fixture
def port():
    """Return a random port to use for the API."""

    return random.randint(5000, 5999)


@pytest.fixture
def endpoint():
    """Return the endpoint to use for the API test."""

    return "spec"


@pytest.fixture
def payload(host, port, endpoint):
    """Return the payload to use for the API test."""

    return {"url": f"http://{host}:{port}/{endpoint}", "timeout": 1}


@pytest.fixture
def pipe():
    """Return a descriptor to use for the server subprocess."""

    return subprocess.PIPE


@pytest.fixture
def server(host, port, pipe):
    """Return a server subprocess."""

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

    with subprocess.Popen(cmd, stdout = pipe, stderr = pipe) as proc:
        try:
            _, out = proc.communicate(timeout = 1)

        except TimeoutExpired as error:
            out = error.stderr

        if f"Listening at: http://{host}:{port} ({proc.pid})" in str(out):
            yield
            proc.terminate()

        else:
            proc.terminate()
            raise SubprocessError(f"Failed to start!\n{out.decode('utf-8')}")


def test_openfisca_server(server, payload):
    """Test the OpenFisca API serves the /spec endpoint."""

    with request.urlopen(**payload) as response:
        data = json.loads(response.read().decode("utf-8"))
        assert data["info"]["title"] == "Openfisca-Country-Template Web API"
