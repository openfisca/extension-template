# OpenFisca Extension-Template

This repository is here to help you bootstrap your own OpenFisca [extension](http://openfisca.org/doc/contribute/extensions.html) package.

**You should NOT fork it but [download a copy](https://github.com/openfisca/extension-template/archive/master.zip) of its source code** and
- change the name `openfisca_extension_template` to reflect your extension's name, e.g. `openfisca_shangrila`
- empty out CHANGELOG.md
- replace the placeholders variables and parameters to suit your own purposes

## Installing

> We recommend that you [use a virtualenv](https://github.com/openfisca/country-template/blob/master/README.md#setting-up-a-virtual-environment-with-pew) to install OpenFisca. If you don't, you may need to add `--user` at the end of all commands starting by `pip`.

To install your extension, run:

```sh
make install-deps install-src
```

## Testing

You can make sure that everything is working by running the provided tests:

```sh
make test-suite
```

> [Learn more about tests](http://openfisca.org/doc/coding-the-legislation/writing_yaml_tests.html).

Your extension package is now installed and ready!

## Troubleshooting

OpenFisca is tested to run under `x64`; with Python `+3.7.9`, `+3.8.10`, and 
`+3.9.13`; and on `OS X`, `Linux`, and `Windows`. If your contributions fail 
in Github Actions, try to reproduce these errors with the follwing command:

```sh
python -m nox -s
```

> You'll need to have Python `3.7.9`, `3.8.10`, and `3.9.13` installed.