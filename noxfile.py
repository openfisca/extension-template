"""Nox config file."""

import nox  # pylint: disable=import-error
import nox_poetry  # pylint: disable=import-error

nox.options.reuse_existing_virtualenvs = False


@nox_poetry.session
@nox.parametrize("python", ("3.7.9", "3.8.10", "3.9.13"))
def e2e(session):
    """Run tests."""
    session.run(
        "make",
        "install-deps",
        "build-dst",
        "install-dst",
        "test-suite",
        external = True,
        )
