#!/usr/bin/env bash

# Check if the script is being executed and not sourced.
if ! (return 0 2>/dev/null); then
  echo "This script should be sourced, not executed."
  exit 1
fi

# Check if the functions are already defined.
if [ -z "$(checks::we_are_in_ci)" ] || [ -z "$(checks::repo_exists)" ]; then
  # Set the root directory where the source script is located (unit testing).
  VALIDATE_DIR="$(dirname "${BASH_SOURCE[0]}")"

  # Source the source script with the required functions.
  source "${VALIDATE_DIR}/_checks.sh"
else
  # Set the root directory where the built script is located.
  VALIDATE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
fi

function validate::repo() {
  local we_are_in_ci
  local repo_exists
  we_are_in_ci="$(checks::we_are_in_ci)"
  repo_exists="$(checks::repo_exists)"
  if ! $we_are_in_ci && $repo_exists; then
    echo "It seems you cloned this repository, or already initialised it."
    echo "Refusing to go further as you might lose work."
    echo "If you are certain this is a new repository, run"
    echo "'cd $VALIDATE_DIR && rm -rf .git' to erase the history."
    exit 2
  fi
}
