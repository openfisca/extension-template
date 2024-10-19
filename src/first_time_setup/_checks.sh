#!/usr/bin/env bash

# Check if the script is being executed and not sourced.
if ! (return 0 2>/dev/null); then
  echo "This script should be sourced, not executed."
  exit 1
fi

# Check if the script should run in non-interactive mode.
function checks::non_interactive() {
  [ -z "$JURISDICTION_NAME" ] && echo false
  [ -z "$REPOSITORY_URL" ] && echo false
  echo true
}

# Check if the script is running in a CI environment.
function checks::we_are_in_ci() {
  [ -z "$CI" ] && echo false
  [ "$CI" == "0" ] && echo false
  [ "$CI" == "false" ] && echo false
  echo true
}

# Check if the repository exists.
function checks::repo_exists() {
  local result
  result=$(git rev-parse --is-inside-work-tree &>/dev/null && echo $? || echo $?)
  [ "$result" -eq 0 ] && echo true || echo false
}
