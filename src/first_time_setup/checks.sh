#!/bin/bash
# @name checks
# @deps utils/boolean utils/git
# @brief A package for checks and validations.

# Exit immediately if a command exits with a non-zero status.
set -o errexit

# Treat unset variables as an error and exit immediately.
set -o nounset

# Prevent errors in a pipeline from being masked.
set -o pipefail

source 'src/first_time_setup/utils/boolean.sh'
source 'src/first_time_setup/utils/git.sh'

# @description Check if the script should run in non-interactive mode.
# @arg $1 The jurisdiction name.
# @arg $2 The repository URL.
is::interactive() {
  local -r name=${1:-}
  local -r url=${2:-}
  if [[ -z ${name} ]]; then echo true && return; fi
  if [[ -z ${url} ]]; then echo true && return; fi
  echo false
}

# @description Check if the script is running in a CI environment.
# @arg $1 The CI environment variable.
is::ci() {
  is::true "${1:-}"
}

# @description Check if the repository exists.
is::repo() {
  is::inside_working_tree
}

# @description Check if the setup should persevere.
# @arg $1 If we are in a CI environment.
# @arg $2 If the repository exists.
setup::persevere() {
  local -r ci=${1:-}
  local -r repo=${2:-}
  local is_ci
  local is_repo
  is_ci=$(is::true "${ci}")
  is_repo=$(is::true "${repo}")
  readonly is_ci
  readonly is_repo
  if ! ${is_ci} && ${is_repo}; then echo false && return; fi
  echo true
}
