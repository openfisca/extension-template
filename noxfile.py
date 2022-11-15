"""Nox config file."""

import nox
import nox_poetry

nox.options.reuse_existing_virtualenvs = True


@nox_poetry.session
@nox.parametrize("python", ("3.7.15", "3.8.15", "3.9.15"))
def test(session):
    """Run tests."""

    session.run("make", "install", external = True, silent = True)
    session.install(".", silent = True)
    session.run("make", "test", external = True)
