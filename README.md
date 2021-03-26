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
make install
```

## Testing

You can make sure that everything is working by running the provided tests:

```sh
make test
```

> [Learn more about tests](http://openfisca.org/doc/coding-the-legislation/writing_yaml_tests.html).

Your extension package is now installed and ready!

## Style

This repository adheres to a certain coding style, and we invite you to follow it for your contributions to be integrated promptly.

Style checking is already run with `make test`. To run the style checker alone:

```sh
make check-style
```

To automatically style-format your code changes:

```sh
make format-style
```

To automatically style-format your code changes each time you commit:

```sh
touch .git/hooks/pre-commit
chmod +x .git/hooks/pre-commit

tee -a .git/hooks/pre-commit << END
#!/bin/sh
#
# Automatically format your code before committing.
exec make format-style
END
```
