all: test

uninstall:
	rm -rf ./lib
	poetry env remove --all
	pip freeze | grep -v "^-e" | sed "s/@.*//" | xargs pip uninstall -y

clean:
	rm -rf build dist
	find . -name '*.pyc' -exec rm \{\} \;
	find . -type d -name '__pycache__' -exec rm -r {} +

install:
	@# Install OpenFisca-Extension-Template for development.
	@# The editable version of OpenFisca-Extension-Template allows contributors
	@# to test as they code.
	/bin/bash bashdep.sh
	poetry install --all-extras --sync

format:
	@# Do not analyse .gitignored files.
	@# `make` needs `$$` to output `$`. Ref: http://stackoverflow.com/questions/2382764.
	poetry run ruff format `git ls-files | grep "\.py$$"`
	poetry run isort `git ls-files | grep "\.py$$"`
	poetry run mdformat --wrap 79 --number `git ls-files | grep "\.md$$"`
	poetry run shfmt --write --simplify `git ls-files | grep "\.sh$$"`

lint: clean
	@# Do not analyse .gitignored files.
	@# `make` needs `$$` to output `$`. Ref: http://stackoverflow.com/questions/2382764.
	poetry run isort --check `git ls-files | grep "\.py$$"`
	poetry run ruff check `git ls-files | grep "\.py$$"`
	poetry run yamllint `git ls-files | grep "\.yaml$$"`
	poetry run mdformat --wrap 79 --number --check `git ls-files | grep "\.md$$"`
	poetry run shellcheck `git ls-files | grep "\.sh$$"`

test: clean
	poetry run openfisca test --country-package=openfisca_country_template --extensions=openfisca_extension_template tests
	lib/bashunit --parallel --simple tests/**/*.sh
