ifeq ($(OS),Windows_NT)
    SHELL := bash.exe
else
    SHELL := /usr/bin/env bash
endif

.SHELLFLAGS := -eo pipefail -c
.DEFAULT_GOAL := all

all: install-deps install-src test-suite
test-suite: format type lint test

uninstall:
	pip freeze | grep -v "^-e" | sed "s/@.*//" | xargs pip uninstall -y

install-deps:
	python -m pip install --upgrade nox pip poetry nox-poetry

install-src: compile clean
	@# Install OpenFisca-Extension-Template for development. `make install`
	@# installs the editable version of OpenFisca-Extension-Template. This
	@# allows contributors to test as they code.
	python -m poetry install --all-extras

build-dst: compile clean
	@# `make build` allows us to test against the packaged version of
	@# of OpenFisca-Extension-Template, the same we put in the hands of users.
	python -m poetry build

install-dst:
	@# Install OpenFisca-Extension-Template for deployment and publishing.
	python -m pip uninstall --yes openfisca-extension-template
	find dist -name "*.whl" -exec pip install --force-reinstall {}[dev] \;

format: compile clean
	@# Do not analyse .gitignored files.
	python -m poetry run isort `git ls-files | grep "\.py$$"`
	python -m poetry run autopep8 `git ls-files | grep "\.py$$"`
	python -m poetry run pyupgrade `git ls-files | grep "\.py$$"` --py37-plus --keep-runtime-typing

type: compile clean
	@# Do not analyse .gitignored files.
	python -m poetry run mypy `git ls-files | grep "\.py$$"`

lint: compile clean
	@# Do not analyse .gitignored files.
	python -m poetry run flake8 `git ls-files | grep "\.py$$"`
	python -m poetry run pylint `git ls-files | grep "\.py$$"`

test: compile clean
	python -m poetry run openfisca test `git ls-files | grep "test_.*\.yaml$$"` --country-package openfisca_country_template --extensions openfisca_extension_template
	sh src/openfisca_extension_template/tests/test-api.sh

compile:
	@python -m compileall -q src

clean:
	@rm -rf build dist
	@find . -name '*.pyc' -exec rm \{\} \;
