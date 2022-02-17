# OpenFisca Extension-Template

This repository is here to help you bootstrap your own OpenFisca [extension](http://openfisca.org/doc/contribute/extensions.html) package.

**You should NOT fork it but [download a copy](https://github.com/openfisca/extension-template/archive/master.zip) of its source code** and
- change the name `openfisca_extension_template` to reflect your extension's name, e.g. `openfisca_shangrila`
- empty out CHANGELOG.md
- replace the placeholders variables and parameters to suit your own purposes

## Installing

### Installing with pew

> We recommend that you [use a virtualenv](https://github.com/openfisca/country-template/blob/master/README.md#setting-up-a-virtual-environment-with-pew) to install OpenFisca. If you don't, you may need to add `--user` at the end of all commands starting by `pip`.

To install your extension, run:

```sh
make install
```
### Installing with conda

Since version [1.3.11](https://anaconda.org/openfisca/openfisca-extension-template), you could use conda to install OpenFisca-Extension-Template with these commands to run in `Anaconda Powershell Prompt` :
- `conda create --name openfisca-ext-tplt python=3.7` to create an openfisca environment.
- `conda activate openfisca-ext-tplt` to use your new environment.
- `conda install -c openfisca openfisca-extension-template` to install the package and all dependencies.

Conda is the easiest way to use OpenFisca under Windows as by installing Anaconda you will get:
- Python
- The package manager [Anaconda.org](https://docs.anaconda.com/anacondaorg/user-guide/)
- A virtual environment manager : [conda](https://docs.conda.io/projects/conda/en/latest/user-guide/tasks/manage-environments.html)
- A GUI [Anaconda Navigator](https://docs.anaconda.com/anaconda/navigator/index.html) if you choose to install the full [Anaconda](https://www.anaconda.com/products/individual)

If you are familiar with command line you could use [Miniconda](https://docs.conda.io/projects/conda/en/latest/user-guide/install/windows.html), wich need very much less disk space than Anaconda.

For informations on how we publish to conda-forge, see [README](.conda/README.md).

## Testing

You can make sure that everything is working by running the provided tests:

```sh
make test
```

> [Learn more about tests](http://openfisca.org/doc/coding-the-legislation/writing_yaml_tests.html).

Your extension package is now installed and ready!
