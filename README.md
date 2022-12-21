# OpenFisca Extension-Template

This repository is here to help you bootstrap your own OpenFisca [extension](http://openfisca.org/doc/contribute/extensions.html) package.

**You should NOT fork it but [download a copy](https://github.com/openfisca/extension-template/archive/master.zip) of its source code** and
- change the name `openfisca_extension_template` to reflect your extension's name, e.g. `openfisca_shangrila`
- empty out CHANGELOG.md
- replace the placeholders variables and parameters to suit your own purposes

## Installing

> We recommend you to use an [isolated](https://pypi.org/project/pipx/)
> environment manager to manage build and extension dependencies separately:

```sh
pipx install poetry
pipx install tox
```

> We also recommend you to use a [virtualenv](https://github.com/pyenv/pyenv-virtualenv)
> manager to install OpenFisca:

```sh
pyenv install 3.9.16
pyenv virtualenv 3.9.16 my-super-duper-extension-3.9.16
cd ~/path/where/is/my-super-duper-extension-3.9.16
pyenv local my-super-duper-extension-3.9.16
```

To install your extension for development, run:

```sh
make install
```

## Testing

You can make sure that everything is working by running the provided tests:

```sh
make lint test test-api
```

> [Learn more about tests](http://openfisca.org/doc/coding-the-legislation/writing_yaml_tests.html).

Your extension package is now installed and ready!
