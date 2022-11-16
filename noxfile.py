"""Nox config file."""

import nox  # pylint: disable=import-error
import nox_poetry  # pylint: disable=import-error

nox.options.reuse_existing_virtualenvs = True


@nox_poetry.session
@nox.parametrize("python", ("3.7.9", "3.8.10", "3.9.13"))
def dependencies(session):
    """Run tests."""
    session.run("make", "dependencies", external = True)


@nox_poetry.session
@nox.parametrize("python", ("3.7.9", "3.8.10", "3.9.13"))
def install(session):
    """Run tests."""
    session.run("make", "install", external = True)


@nox_poetry.session
@nox.parametrize("python", ("3.7.9", "3.8.10", "3.9.13"))
def build(session):
    """Run tests."""
    session.run("make", "build", external = True)


@nox_poetry.session
@nox.parametrize("python", ("3.7.9", "3.8.10", "3.9.13"))
def test(session):
    """Run tests."""
    session.run("make", "test", external = True)
