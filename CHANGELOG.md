# Changelog

### 2.0.7 - [#65](https://github.com/openfisca/extension-template/pull/65)

- Minor change.
- Impacted areas: `tests`
- Details:
  - Adapt to `country-template` 8.0.0

### 2.0.6 - [#64](https://github.com/openfisca/extension-template/pull/64)

- Minor change.
- Impacted areas: `pyproject.toml`
- Details:
  - Include tests on distribution for integration testing

### 2.0.5 - [#58](https://github.com/openfisca/extension-template/pull/58)

- Technical Changes
- Details:
  - Add `Taskfile` to replace `Makefile`

### 2.0.4 - [#62](https://github.com/openfisca/extension-template/pull/62)

- Technical improvement
- Impacted areas: `all`
- Details:
  - Adopt src layout to avoid importing bugs and properly testing built
    versions

### 2.0.3 - [#61](https://github.com/openfisca/extension-template/pull/61)

- Minor change.
- Impacted areas: `**/*.sh`
- Details:
  - Add `shellcheck` and `shfmt` (shell formatter)

### 2.0.2 - [#60](https://github.com/openfisca/extension-template/pull/60)

- Minor change.
- Impacted areas: `README.md`
- Details:
  - Adapt README.md from country-template

### 2.0.1 - [#59](https://github.com/openfisca/extension-template/pull/59)

- Minor change.
- Impacted areas: `**/*.md`
- Details:
  - Apply formatter to markdown files

# 2.0.0 - [#54](https://github.com/openfisca/extension-template/pull/54)

- Technical Changes
- Details:
  - Run tests in absolute isolation
    - Uses `poetry` to ensure deterministic builds
    - Uses `tox` to test builds in isolation

### 1.3.15 - [#57](https://github.com/openfisca/extension-template/pull/57)

- Crash fix.
- Details:
  - Add pyproject.toml
  - Fix variables not being loaded
  - Upgrade country-template to latest

### 1.3.14 - [#55](https://github.com/openfisca/extension-template/pull/55)

- Technical improvement.
- Details:
  - Use PyPi token for authentication on CI `deploy` job
  - Allows for Python package upload since the 2FA enforcement on PyPi

### 1.3.13 - [#53](https://github.com/openfisca/extension-template/pull/53)

- Minor change.
- Details:
  - Improve format with isort & pyupgrade
    - This to help transition to py3.8 and np1.21+

### 1.3.12 - [#52](https://github.com/openfisca/extension-template/pull/52)

- Minor change.
- Details:
  - Add .editorconfig for consistency of editor settings across packages

### 1.3.11 - [#51](https://github.com/openfisca/extension-template/pull/51)

- Technical Changes
- Details:
  - Migrate from CircleCI to Github Actions

### 1.3.10 - [#42](https://github.com/openfisca/extension-template/pull/42)

- Technical change
- Details:
  - Add tar.gz to PyPi to be used by conda to build conda package.

### 1.3.9 - [#37](https://github.com/openfisca/extension-template/pull/37)

- Technical change
- Details:
  - Migrate from deprecated Dependabot.com to GitHub-native Dependabot service
  - Allows to track the dependencies updates according to new
    `.github/dependabot.yml` configuration file

### 1.3.8 - [#35](https://github.com/openfisca/extension-template/pull/35)

- Minor change.
- Details:
  - Add support for `flake8-bugbear` < 22

### 1.3.7 - [#33](https://github.com/openfisca/extension-template/pull/33)

- Minor change.
- Details:
  - Add support for `flake8-print` < 5

### 1.3.6 - [#36](https://github.com/openfisca/extension-template/pull/36)

- Technical improvement.
- Details:
  - Forces the installation of the new build each time `make build` is run
  - CircleCI tests against the packaged version of this library
    - When a branch is pushed first time, CircleCI creates a build and caches
      dependencies
    - Subsequent pushes do not reinstall the build as it is already in cache
    - If the code has been modified in between, changes will be ignored, and
      tests will fail

### 1.3.5 - [#32](https://github.com/openfisca/extension-template/pull/32)

- Technical improvement.
- Impacted areas: `**/*`
- Details:
  - Make style checks stricter and clearer to help country package developers
    get started

### 1.3.4 - [#28](https://github.com/openfisca/extension-template/pull/28)

- Minor change.
- Details:
  - Upgrade `autopep8`, `flake8` & `pycodestyle`

### 1.3.3 - [#25](https://github.com/openfisca/extension-template/pull/25)

- Technical change
- Details:
  - Upgrade `autopep8`

### 1.3.2 - [#24](https://github.com/openfisca/extension-template/pull/24)

- Technical change
- Details:
  - Update `autopep8`

### 1.3.1 - [#22](https://github.com/openfisca/extension-template/pull/22)

- Technical change
- Details:
  - Update `flake8`, `autopep8` and `pycodestyle`

## 1.3.0 -

- Technical change
- Details:
  - Remove Python 2 build and deploy on continuous integration
  - Update test command
  - Update `country-template` dependency (uses Core v27)

## 1.2.0 - [#18](https://github.com/openfisca/extension-template/pull/18)

- Technical change
- Details:
  - Adapt to OpenFisca Core v25
  - Change the syntax of OpenFisca YAML tests

For instance, a test that was using the `input_variables` and the
`output_variables` keywords like:

```yaml
- name: Basic income
  period: 2016-12
  input_variables:
    salary: 1200
  output_variables:
    basic_income: 600
```

becomes:

```yaml
- name: Basic income
  period: 2016-12
  input:
    salary: 1200
  output:
    basic_income: 600
```

A test that was fully specifying its entities like:

```yaml
- name: "A couple with 2 children gets 200€"
  period: 2016-01
  households:
    parents: ["parent1", "parent2"]
    children: ["child1", "child2"]
  persons:
  - id: "parent1"
    age: 35
  - id: "parent2"
    age: 35
  - id: "child1"
    age: 8
  - id: "child2"
    age: 4
  output_variables:
    local_town_child_allowance: 200
```

becomes:

```yaml
- name: "A couple with 2 children gets 200€"
  period: 2016-01
  input:
    households:
      household:
        parents: ["parent1", "parent2"]
        children: ["child1", "child2"]
    persons:
      parent1:
        age: 35
      parent2:
        age: 35
      child1:
        age: 8
      child2:
        age: 4
  output:
    local_town_child_allowance: 200
```

### 1.1.7 - [#16](https://github.com/openfisca/extension-template/pull/16)

- Technical change
- Details:
  - Tests library against its packaged version
  - By doing so, we prevent some hideous bugs

### 1.1.6 - [#15](https://github.com/openfisca/extension-template/pull/15)

_Note: the 1.1.5 version has been unpublished as it was used for test analysis_

- Add continuous deployment with CircleCI, triggered by a merge to `master`
  branch

### 1.1.4 - [#13](https://github.com/openfisca/extension-template/pull/13)

- Declare package compatible with OpenFisca Country Template v3

### 1.1.3 - [#8](https://github.com/openfisca/extension-template/pull/8)

- Technical improvement:
- Details:
  - Adapt to version `21.0.0` of Openfisca-Core and version `2.1.0` of
    Country-Template

### 1.1.2 - [#7](https://github.com/openfisca/extension-template/pull/7)

- Technical improvement:
- Details:
  - Adapt to version `20.0.0` of Openfisca-Core and version `1.4.0` of
    Country-Template

### 1.1.1 - [#5](https://github.com/openfisca/extension-template/pull/5)

- Technical improvement: adapt to version `17.0.0` of Openfisca-Core and
  version `1.2.4` of Country-Template
- Details:
  - Transform XML parameter files to YAML parameter files.
  - Gather tests in the directory `tests`. The command `make test` runs only
    the tests contained in that directory.
  - Add a changelog.

# Example Entry

### 0.0.1 - [#0](https://github.com/openfisca/openfisca-extension-template/pull/0)

- Tax and benefit system evolution.
- Impacted periods: all.
- Impacted areas:
  - `parameters`.
  - `variables`.
- Details:
  - Import extension from template
