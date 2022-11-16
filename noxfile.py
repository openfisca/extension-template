"""Nox config file."""

import nox
import nox_poetry

nox.options.reuse_existing_virtualenvs = False


@nox_poetry.session
@nox.parametrize("python", ("3.7.9", "3.8.10", "3.9.13"))
def test(session):
    """Run tests."""
    session.run("make", "install", external = True)
    session.install(".")
    session.run("make", "test", external = True)
