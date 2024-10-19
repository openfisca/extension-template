#!/usr/bin/env bash

# Check if the script is being executed and not sourced.
if ! (return 0 2>/dev/null); then
  echo "This script should be sourced, not executed."
  exit 1
fi

# Print an error message and exit.
function helpers::error_and_exit() {
  echo "You need to provide a formatter function."
  exit 2
}

# Define the welcome message.
_MSG_WELCOME=$(
  cat <<MSG
Welcome to the OpenFisca Extension Template setup script.

    This script will guide you through the process of setting up a new
    OpenFisca jurisdiction from start to finish. We will start now...
MSG
)
declare -r MSG_WELCOME="${_MSG_WELCOME}"

# Tip to define the jurisdiction with an environment variable.
_MSG_TIP_JURISDICTION_NAME=$(
  cat <<MSG
[Tip: you can define the jurisdiction name with an environment variable.
    For example, 'export JURISDICTION_NAME="New Zealand"'.]
MSG
)
declare -r MSG_TIP_JURISDICTION_NAME="${_MSG_TIP_JURISDICTION_NAME}"

# Tip to define the repository URL with an environment variable.
_MSG_TIP_REPOSITORY_URL=$(
  cat <<MSG
[Tip: you can define the repository URL with an environment variable.
    For example, 'export REPOSITORY_URL="https://git.paris.fr/openfisca/paris"'.]
MSG
)
declare -r MSG_TIP_REPOSITORY_URL="${_MSG_TIP_REPOSITORY_URL}"

# Define the ci/repo validation message.
_MSG_DO_NOT_PERSEVERE=$(
  cat <<MSG
It seems you cloned this repository, or already initialised it. Refusing to go
    further as you might lose work. If you are certain this is a new repository, run
    'cd "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)" && rm -rf .git'
    to erase the history.
MSG
)
declare -r MSG_DO_NOT_PERSEVERE="${_MSG_DO_NOT_PERSEVERE}"

# Define the prompt for the jurisdiction name.
_MSG_PROMPT_NAME=$(
  cat <<-TEXT
The name of the jurisdiction (usually a country, e.g. New Zealand, France…)
you will model the rules of:
TEXT
)
declare -r MSG_PROMPT_NAME="${_MSG_PROMPT_NAME}"

# Define the prompt for the url of the repository.
_MSG_PROMPT_URL=$(
  cat <<-TEXT
Your Git repository URL: (i.e. https://githost.example/organisation/openfisca-jurisdiction)
TEXT
)
declare -r MSG_PROMPT_URL="${_MSG_PROMPT_URL}"

# Export the variables.
export MSG_WELCOME MSG_DO_NOT_PERSEVERE MSG_TIP_JURISDICTION_NAME MSG_TIP_REPOSITORY_URL
export MSG_PROMPT_NAME MSG_PROMPT_URL
