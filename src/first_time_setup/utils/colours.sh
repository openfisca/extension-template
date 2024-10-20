#!/bin/bash
# @name colours
# @brief A package for coloring output and messages.

# Exit immediately if a command exits with a non-zero status.
set -o errexit

# Treat unset variables as an error and exit immediately.
set -o nounset

# Prevent errors in a pipeline from being masked.
set -o pipefail

# @internal
::task() {
  local colour
  colour=$(tput setaf 5)
  echo -n "${colour}"
}

# @internal
::user() {
  local colour
  colour=$(tput setaf 4)
  echo -n "${colour}"
}

# @internal
::pass() {
  local colour
  colour=$(tput setaf 6)
  echo -n "${colour}"
}

# @internal
::warn() {
  local colour
  colour=$(tput setaf 3)
  echo -n "${colour}"
}

# @internal
::fail() {
  local colour
  colour=$(tput setaf 1)
  echo -n "${colour}"
}

# @internal
::done() {
  local colour
  colour=$(tput setaf 2)
  echo -n "${colour}"
}

# @internal
::info() {
  local colour
  colour=$(tput setaf 7)
  echo -n "${colour}"
}

# @internal
::none() {
  local colour
  colour=$(tput sgr0)
  echo -n "${colour}"
}

# @description Coloring task messages.
# @arg $1 string A value to colorise.
colour::task() {
  local -r input="${1}"
  local task
  local none
  local msg
  task="$(::task)"
  none="$(::none)"
  msg="${task}[⚙] ${input}${none}"
  echo -e "${msg}"
}

# @description Coloring user prompts.
# @arg $1 string A value to colorise.
colour::user() {
  local -r input="${1}"
  local user
  local none
  local msg
  user="$(::user)"
  none="$(::none)"
  msg="${user}[❯] ${input}${none}"
  echo -e "${msg}"
}

# @description Coloring work-in-progress operations.
# @arg $1 string A value to colorise.
colour::pass() {
  local -r input="${1}"
  local pass
  local none
  local msg
  pass="$(::pass)"
  none="$(::none)"
  msg="${pass}[λ] ${input}${none}"
  echo -e "${msg}"
}

# @description Coloring warnings.
# @arg $1 string A value to colorise.
colour::warn() {
  local -r input="${1}"
  local warn
  local none
  local msg
  warn="$(::warn)"
  none="$(::none)"
  msg="${warn}[!] ${input}${none}"
  echo -e "${msg}"
}

# @description Coloring failed operations.
# @arg $1 string A value to colorise.
colour::fail() {
  local -r input="${1}"
  local fail
  local none
  local msg
  fail="$(::fail)"
  none="$(::none)"
  msg="${fail}[x] ${input}${none}"
  echo -e "${msg}"
}

# @description Coloring finished operations.
# @arg $1 string A value to colorise.
colour::done() {
  local -r input="${1}"
  local done_
  local none
  local msg
  done_="$(::done)"
  none="$(::none)"
  msg="${done_}[✓] ${input}${none}"
  echo -e "${msg}"
}

# @description Coloring information messages.
# @arg $1 string A value to colorise.
colour::info() {
  local -r input="${1}"
  local info
  local none
  local msg
  info="$(::info)"
  none="$(::none)"
  msg="${info}[i] ${input}${none}"
  echo -e "${msg}"
}
