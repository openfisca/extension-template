#!/bin/bash
# @name colours
# @brief A package for coloring output and messages.

# Exit immediately if a command exits with a non-zero status.
set -o errexit

# Treat unset variables as an error and exit immediately.
set -o nounset

# Prevent errors in a pipeline from being masked.
set -o pipefail

# Make word splitting happen only on newlines and tab characters."
IFS=$'\n\t'

# Array to store colours.
__colours__=()
__colours__+=("$(tput setaf 5)")
__colours__+=("$(tput setaf 4)")
__colours__+=("$(tput setaf 6)")
__colours__+=("$(tput setaf 3)")
__colours__+=("$(tput setaf 1)")
__colours__+=("$(tput setaf 2)")
__colours__+=("$(tput setaf 7)")
__colours__+=("$(tput sgr0)")
readonly __colours__

# @internal
.err() {
  local msg
  msg=$(colours::fail "${1}")
  echo -e "${msg}" >&2
}

# @description Coloring task messages.
# @arg $1 string A value to colorise.
colours::task() {
  local input="${1}"
  local msg
  msg="${__colours__[0]}[⚙] ${input}${__colours__[7]}"
  echo -e "${msg}"
}

# @description Coloring user prompts.
# @arg $1 string A value to colorise.
colours::user() {
  local input="${1}"
  local msg
  msg="${__colours__[1]}[❯] ${input}${__colours__[7]}"
  echo -e "${msg}"
}

# @description Coloring work-in-progress operations.
# @arg $1 string A value to colorise.
colours::pass() {
  local input="${1}"
  local msg
  msg="${__colours__[2]}[λ] ${input}${__colours__[7]}"
  echo -e "${msg}"
}

# @description Coloring warnings.
# @arg $1 string A value to colorise.
colours::warn() {
  local input="${1}"
  local msg
  msg="${__colours__[3]}[!] ${input}${__colours__[7]}"
  echo -e "${msg}"
}

# @description Coloring failed operations.
# @arg $1 string A value to colorise.
colours::fail() {
  local input="${1}"
  local msg
  msg="${__colours__[4]}[x] ${input}${__colours__[7]}"
  echo -e "${msg}"
}

# @description Coloring finished operations.
# @arg $1 string A value to colorise.
colours::done() {
  local input="${1}"
  local msg
  msg="${__colours__[5]}[✓] ${input}${__colours__[7]}"
  echo -e "${msg}"
}

# @description Coloring information messages.
# @arg $1 string A value to colorise.
colours::info() {
  local input="${1}"
  local msg
  msg="${__colours__[6]}[i] ${input}${__colours__[7]}"
  echo -e "${msg}"
}

# @description Main
# Make file not executable.
# @global BASH_SOURCE
main() {
  if [[ "${BASH_SOURCE[0]}" -ef "$0" ]]; then
    .err 'This script is meant to be sourced, not executed.'
    exit 1
  fi
}

main "$@"
