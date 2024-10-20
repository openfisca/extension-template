#!/usr/bin/env bash

# Check if the script is being executed and not sourced.
if ! (return 0 2>/dev/null); then
  echo "This script should be sourced, not executed."
  exit 1
fi

# Check if the script should run in non-interactive mode.
function checks::non_interactive() {
  [[ -z $JURISDICTION_NAME ]] && echo false && return
  [[ -z $REPOSITORY_URL ]] && echo false && return
  echo true
}

# Check if the script is running in a CI environment.
function checks::we_are_in_ci() {
  [[ -z $CI ]] && echo false && return
  [[ $CI == "0" ]] && echo false && return
  [[ $CI == "false" ]] && echo false && return
  echo true
}

# Check if the repository exists.
function checks::repo_exists() {
  local result
  result=$(git rev-parse --is-inside-work-tree &>/dev/null && echo $? || echo $?)
  [[ $result -eq 0 ]] && echo true && return || echo false
}

function checks::persevere() {
  local we_are_in_ci
  local repo_exists
  we_are_in_ci=$(checks::we_are_in_ci)
  repo_exists=$(checks::repo_exists)
  if ! $we_are_in_ci && $repo_exists; then
    echo false && return
  else
    echo true
  fi
}
