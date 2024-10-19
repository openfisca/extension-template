#!/usr/bin/env bash

# Check if the script is being executed and not sourced.
if ! (return 0 2>/dev/null); then
  echo "This script should be sourced, not executed."
  exit 1
fi

# The name of the jurisdiction, e.g. "United Kingdom", "Paris", etc.
declare -r JURISDICTION_NAME=${JURISDICTION_NAME:-}
# The URL of the repository, e.g. "https://git.paris.fr/openfisca/paris"
declare -r REPOSITORY_URL=${REPOSITORY_URL:-}
# Whether we are in a CI environment.
declare -r CI=${CI:-}

# Export the variables.
export JURISDICTION_NAME REPOSITORY_URL CI
