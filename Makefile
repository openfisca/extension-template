all: test

uninstall:
	poetry env remove --all

clean:
	rm -rf build dist
	find . -name '*.pyc' -exec rm \{\} \;
	find . -type d -name '__pycache__' -exec rm -r {} +

install:
	@# Install OpenFisca-Extension-Template for development.
	@# The editable version of OpenFisca-Extension-Template allows contributors
	@# to test as they code.
	poetry install --all-extras --sync

format:
	@# Do not analyse .gitignored files.
	@# `make` needs `$$` to output `$`. Ref: http://stackoverflow.com/questions/2382764.
	poetry run black `git ls-files | grep "\.py$$"`
	poetry run isort `git ls-files | grep "\.py$$"`
	poetry run pyproject-fmt pyproject.toml
	poetry run ruff format `git ls-files | grep "\.py$$"`

lint: clean
	@# Do not analyse .gitignored files.
	@# `make` needs `$$` to output `$`. Ref: http://stackoverflow.com/questions/2382764.
	poetry run black --check `git ls-files | grep "\.py$$"`
	poetry run isort --check `git ls-files | grep "\.py$$"`
	poetry run ruff check `git ls-files | grep "\.py$$"`
	poetry run yamllint `git ls-files | grep "\.yaml$$"`

test: clean
	PYTEST_ADDOPTS="--import-mode importlib" poetry run openfisca test --country-package=openfisca_country_template --extensions=openfisca_extension_template openfisca_extension_template/tests
