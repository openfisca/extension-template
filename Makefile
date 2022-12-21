all: test

uninstall:
	pip freeze | grep -v "^-e" | sed "s/@.*//" | xargs pip uninstall -y

clean:
	rm -rf build dist
	find . -name '*.pyc' -exec rm \{\} \;

install:
	@# Install OpenFisca-Extension-Template for development.
	@# The editable version of OpenFisca-Extension-Template allows contributors
	@# to test as they code.
	pip install --upgrade pip
	poetry install --sync

check-syntax-errors:
	python -m compileall -q .

format:
	@# Do not analyse .gitignored files.
	@# `make` needs `$$` to output `$`. Ref: http://stackoverflow.com/questions/2382764.
	poetry run autopep8 `git ls-files | grep "\.py$$"`

lint: clean check-syntax-errors
	@# Do not analyse .gitignored files.
	@# `make` needs `$$` to output `$`. Ref: http://stackoverflow.com/questions/2382764.
	poetry run flake8 `git ls-files | grep "\.py$$"`
	poetry run pylint `git ls-files | grep "\.py$$"`
	poetry run yamllint `git ls-files | grep "\.yaml$$"`

test: clean check-syntax-errors
	openfisca test openfisca_extension_template/tests --country-package openfisca_country_template --extensions openfisca_extension_template

test-api:
	./.github/test-api.sh
