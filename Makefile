all: test

uninstall:
	pip freeze | grep -v "^-e" | sed "s/@.*//" | xargs pip uninstall -y

clean:
	rm -rf build dist
	find . -name '*.pyc' -exec rm \{\} \;
	find . -type d -name '__pycache__' -exec rm -r {} +

install:
	@# Install OpenFisca-Extension-Template for development.
	@# The editable version of OpenFisca-Extension-Template allows contributors
	@# to test as they code.
	pip install --upgrade pip
	poetry install --all-extras --sync

format:
	@# Do not analyse .gitignored files.
	@# `make` needs `$$` to output `$`. Ref: http://stackoverflow.com/questions/2382764.
	black `git ls-files | grep "\.py$$"`
	isort `git ls-files | grep "\.py$$"`
	pyproject-fmt pyproject.toml
	ruff format `git ls-files | grep "\.py$$"`

lint: clean
	@# Do not analyse .gitignored files.
	@# `make` needs `$$` to output `$`. Ref: http://stackoverflow.com/questions/2382764.
	black --check `git ls-files | grep "\.py$$"`
	isort --check `git ls-files | grep "\.py$$"`
	ruff check `git ls-files | grep "\.py$$"`
	yamllint `git ls-files | grep "\.yaml$$"`

test: clean
	PYTEST_ADDOPTS="--import-mode importlib" openfisca test --country-package=openfisca_country_template --extensions=openfisca_extension_template openfisca_extension_template/tests
