#!/bin/bash
# @name status
# @brief Gives the status of the setup.

# Exit immediately if a command exits with a non-zero status.
set -o errexit

# Treat unset variables as an error and exit immediately.
set -o nounset

# Prevent errors in a pipeline from being masked.
set -o pipefail

# @description Gather information from environment variables.
# @arg $1 The jurisdiction name.
# @arg $2 The repository URL.
# @arg $3 If it is an interactive mode.
status::gather_info() {
  local -r setup_name="${1}"
  local -r setup_url="${2}"
  local -r setup_is_int="${3}"
  echo ""
  colour::task "Gathering environment variables..."
  echo ""
  colour::pass "Jurisdiction name:"
  echo " =  ${setup_name:-[ unset ]}"
  colour::pass "Repository URL:"
  echo " =  ${setup_url:-[ unset ]}"
  colour::done "Interactive mode (inferred):"
  echo " =  ${setup_is_int}"
}

# @description Check if we can continue.
# @arg $1 If we are in a CI environment.
# @arg $2 If the repository exists.
# @arg $3 If the setup should persevere.
# @arg $4 If the setup should be dry.
status::check_continue() {
  local -r setup_is_ci="${1}"
  local -r setup_is_repo="${2}"
  local -r setup_persevere="${3}"
  local -r setup_dry="${4}"
  echo ""
  colour::task "Checking if we can continue...."
  echo ""
  colour::pass "Are we in a CI environment?"
  echo " =  ${setup_is_ci}"
  colour::pass "Is there an existing repository already?"
  echo " =  ${setup_is_repo}"
  if ${setup_persevere} || ${setup_dry}; then
    colour::done "Can the setup continue?"
    echo " =  ${setup_persevere}"
  else
    colour::warn "Can the setup continue?"
    echo " =  ${setup_persevere}"
  fi
}

# @description Print a pre-setup summary.
# @arg $1 The jurisdiction name.
# @arg $2 The jurisdiction name snake.
# @arg $3 The repository URL.
status::pre_summary() {
  local -r setup_name="${1}"
  local -r setup_name_snake="${2}"
  local -r setup_url="${3}"
  echo ""
  colour::done "Jurisdiction title set to:"
  echo " =  ${setup_name:-[ unset ]}"
  colour::done "Jurisdiction Python label set to:"
  echo " =  ${setup_name_snake:-[ unset ]}"
  colour::done "Git repository URL set to:"
  echo " =  ${setup_url:-[ unset ]}"
}
