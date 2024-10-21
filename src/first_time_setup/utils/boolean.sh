#!/bin/bash
# @name utils/boolean
# @brief A package to check if a value is a boolean.

# Exit immediately if a command exits with a non-zero status.
set -o errexit

# Treat unset variables as an error and exit immediately.
set -o nounset

# Prevent errors in a pipeline from being masked.
set -o pipefail

# @description Check if a value is false.
# @arg $1 The value to check.
is::false() {
  local -r input=${1:-}
  if [[ -z ${input} ]]; then echo true && return; fi
  if [[ ${input} == '0' ]]; then echo true && return; fi
  if [[ ${input} == [Nn] ]]; then echo true && return; fi
  if [[ ${input} == [Nn][Oo] ]]; then echo true && return; fi
  if [[ ${input} == [Ff][Aa][Ll][Ss][Ee] ]]; then echo true && return; fi
  echo false
}

# @description Check if a value is true.
# @arg $1 The value to check.
is::true() {
  local is_false
  is_false=$(is::false "${1}")
  readonly is_false
  if [[ ${is_false} == 'false' ]]; then echo true && return; fi
  echo false
}
