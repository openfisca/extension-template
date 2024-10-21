#!/bin/bash
# @name utils/string
# @deps utils/colours
# @brief A package with utilities for string manipulation.

# Exit immediately if a command exits with a non-zero status.
set -o errexit

# Treat unset variables as an error and exit immediately.
set -o nounset

# Prevent errors in a pipeline from being masked.
set -o pipefail

source 'src/first_time_setup/utils/colours.sh'

# @internal
::error() {
  local -r input="${1}"
  local message
  message=$(colour::fail "${input}")
  readonly message
  echo -e "${message}" >&2
  return 1
}

# @internal
::unidecode::find() {
  local pip
  local poetry
  pip=$(command -v unidecode 2>/dev/null)
  poetry=$(poetry run which unidecode 2>/dev/null)
  readonly pip
  readonly poetry
  if [[ -n ${pip} ]]; then echo "${pip}" && return; fi
  if [[ -n ${poetry} ]]; then echo "${poetry}" && return; fi
  ::error "Unidecode not found. Install it with 'pip install unidecode'."
  return 1
}

# @description Convert a string to lowercase.
# @arg $1 The string to convert.
string::lower() {
  local -r input="${1}"
  echo "${input}" | tr '[:upper:]' '[:lower:]'
}

# @description Decode a string to ASCII.
# @arg $1 The string to decode.
string::decode() {
  local -r input="${1}"
  local unidecode
  unidecode=$(::unidecode::find)
  readonly unidecode
  if [[ -z ${unidecode} ]]; then return 1; fi
  echo "${input}" | "${unidecode}"
}

# @description Remove special characters from a string.
# @arg $1 The string to clean.
string::sanitise() {
  local -r input="${1}"
  local result
  result=$(
    echo "${input}" |
      sed -r 's/[\"'\''«»“”„‟‹›]+/-/g' |
      sed -r 's/[^a-zA-Z _-]+//g'
  )
  readonly result
  echo "${result}"
}

# @description Remove spaces from a string.
# @arg $1 The string to clean.
string::trim() {
  local -r input="${1}"
  local result
  result=$(echo "${input}" | sed -r 's/[ ]+/_/g')
  readonly result
  echo "${result}"
}

# @description Convert a string to snake case.
# @arg $1 The string to convert.
string::snake() {
  local -r input="${1}"
  local result
  result=$(echo "${input}" | sed -r 's/[-]+/_/g')
  readonly result
  echo "${result}"
}
