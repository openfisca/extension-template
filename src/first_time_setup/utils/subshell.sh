#!/bin/bash
# @name subshell
# @brief A package for detecting if the script is being sourced or executed.

# Exit immediately if a command exits with a non-zero status.
set -o errexit

# Treat unset variables as an error and exit immediately.
set -o nounset

# Prevent errors in a pipeline from being masked.
set -o pipefail

# @internal
# @global BASH_SOURCE
# @global BASH_VERSION
::detect() {
  local -r size="${#BASH_SOURCE[@]}"
  local -r tail=$((size - 1))
  if [[ -z ${BASH_VERSION} ]]; then exit 1; fi
  if [[ $0 == "${BASH_SOURCE[${tail}]}" ]]; then echo true; fi
  echo false
}

# @description The script is being executed?
is::executed() {
  ::detect
}

# @description The script is being sourced?
is::sourced() {
  local is_subshell
  is_subshell=$(::detect)
  if [[ -z ${is_subshell} ]]; then echo true; fi
  echo false
}
