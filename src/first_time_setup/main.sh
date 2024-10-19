#!/usr/bin/env bash

# Check if the script is being executed and not sourced.
if ! (return 0 2>/dev/null); then
  echo "This script should be sourced, not executed."
  exit 1
fi

# Define a cleanup functions to be called on script exit or interruption.
trap 'unexpected_error $? $LINENO' ERR
trap interrupted SIGINT
trap cleanup EXIT

# Set the root directory where the script is located.
_ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
declare -r ROOT_DIR="${_ROOT_DIR}"

source "$ROOT_DIR/src/first_time_setup/_checks.sh"
source "$ROOT_DIR/src/first_time_setup/_colours.sh"
source "$ROOT_DIR/src/first_time_setup/_envvars.sh"
source "$ROOT_DIR/src/first_time_setup/_helpers.sh"
source "$ROOT_DIR/src/first_time_setup/_messages.sh"
source "$ROOT_DIR/src/first_time_setup/_validate.sh"
source "$ROOT_DIR/src/first_time_setup/_version.sh"

# Can we continue in interactive mode?
_NON_INTERACTIVE="$(checks::non_interactive)"
declare -r NON_INTERACTIVE="${_NON_INTERACTIVE}"

# Are we in a CI environment?
_WE_ARE_IN_CI="$(checks::we_are_in_ci)"
declare -r WE_ARE_IN_CI="${_WE_ARE_IN_CI}"

# Does the repository exist already?
_REPO_EXISTS="$(checks::repo_exists)"
declare -r REPO_EXISTS="${_REPO_EXISTS}"

# Should we persevere?
_PERSEVERE="$(checks::persevere)"
declare -r PERSEVERE="${_PERSEVERE}"

# Main function to drive the script.
function main() {
  # Print a welcome message.
  main::welcome

  # Gather information from environment variables.
  main::check_for_environment_variables

  # Check if we can continue.
  main::check_if_we_can_continue
}

# Print a welcome message.
function main::welcome() {
  echo ""
  echo -e "$(colours::info "$MSG_WELCOME")"
  echo ""
}

# Gather information from environment variables.
function main::check_for_environment_variables() {
  echo ""
  echo -e "$(colours::task "Gathering environment variables...")"
  echo -e "$(colours::pass "Jurisdiction name: $JURISDICTION_NAME")"
  if [[ ! $JURISDICTION_NAME ]]; then
    echo -e "$(colours::info "$MSG_TIP_JURISDICTION_NAME")"
  fi
  echo -e "$(colours::pass "Repository URL: $REPOSITORY_URL")"
  if [[ ! $REPOSITORY_URL ]]; then
    echo -e "$(colours::info "$MSG_TIP_REPOSITORY_URL")"
  fi
  echo -e "$(colours::done "Non-interactive mode: $NON_INTERACTIVE")"
  echo ""
}

# Check if we can continue based on CI and repository existence.
function main::check_if_we_can_continue() {
  echo ""
  echo -e "$(colours::task "Checking if we can continue....")"
  echo -e "$(colours::pass "CI environment: $WE_ARE_IN_CI")"
  echo -e "$(colours::pass "Existing repository: $REPO_EXISTS")"
  if ! $PERSEVERE; then
    echo -e "$(colours::fail "$MSG_DO_NOT_PERSEVERE")"
    echo ""
    exit 2
  else
    echo -e "$(colours::done "All looks good to continue :)")"
    echo ""
  fi
}

# Unknown error handling.
function unexpected_error() {
  trap - ERR
  echo -e "$(colours::fail "Unexpected error $1 on line $2.")"
}

# User interruption.
function interrupted() {
  trap - ERR
  echo ""
  echo -e "$(colours::warn "Interrupted.")"
}

# Cleanup on exit.
function cleanup() {
  trap - EXIT
  echo ""
  echo -e "$(colours::info "Exiting. Bye!")"
  echo ""
}

# Launch the setup.
main "Let's start the setup."
