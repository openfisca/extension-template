.DEFAULT_GOAL := test

uninstall:
	@python -m pip freeze | grep -v "^-e" | xargs pip uninstall -y

deps:
	@python -m pip install --upgrade \
		nox \
		nox-poetry \
		pip \
		poetry

install: deps
	@# Install OpenFisca-Extension-Template for development. `make install`
	@# installs the editable version of OpenFisca-Extension-Template. This
	@# allows contributors to test as they code.
	@python -m poetry install --extras "test"

compile:
	@python -m compileall -q src

clean:
	@rm -rf build dist
	@find . -name '*.pyc' -exec rm \{\} \;

format: compile clean
	@# Do not analyse .gitignored files.
	@python -m poetry run autopep8 `git ls-files | grep "\.py$$"`

lint: compile clean
	@# Do not analyse .gitignored files.
	@python -m poetry run flake8 `git ls-files | grep "\.py$$"`
	@python -m poetry run pylint `git ls-files | grep "\.py$$"`

test: format lint
	@python -m poetry run openfisca test `git ls-files | grep "test\.yaml$$"` \
		--country-package openfisca_country_template \
		--extensions openfisca_extension_template

build: clean deps
	@# Install OpenFisca-Extension-Template for deployment and publishing.
	@# `make build` allows us to be be sure tests are run against the packaged version
	@# of OpenFisca-Extension-Template, the same we put in the hands of users and reusers.
	@python -m build
	@python -m pip uninstall --yes openfisca-extension-template
	@find dist -name "*.whl" -exec pip install --force-reinstall {}[dev] \;
