#!/bin/bash
# @name messages
# @brief A package for setting the messages used by the setup script.

# Exit immediately if a command exits with a non-zero status.
set -o errexit

# Treat unset variables as an error and exit immediately.
set -o nounset

# Prevent errors in a pipeline from being masked.
set -o pipefail

# Define the version of the setup script.
_version=$(grep '^version =' pyproject.toml | cut -d '"' -f 2)
readonly _version

# Define the directory of the setup script.
_messages_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly _messages_dir

# Define the welcome message.
_msg_welcome=$(
  cat <<MSG
Welcome to the OpenFisca Extension Template setup script v${_version}!

This script will guide you through the process of setting up a new OpenFisca
jurisdiction from start to finish. We will begin now...
MSG
)
declare -xr MSG_WELCOME="${_msg_welcome}"

# Define the ci/repo validation message.
_msg_stop=$(
  cat <<MSG
It seems you cloned this repository, or already initialised it. Refusing to go
    further as you might lose work. If you are certain this is a new repository,
    run 'cd "${_messages_dir}" && rm -rf .git' to erase the history.
MSG
)
declare -xr MSG_STOP="${_msg_stop}"

# Define the prompt for the jurisdiction name.
_msg_prompt_name=$(
  cat <<MSG
The name of the jurisdiction (usually a country, e.g. New Zealand, France…)
    you will model the rules of:
MSG
)
declare -xr MSG_PROMPT_NAME="${_msg_prompt_name}"

# Define the prompt for the url of the repository.
_msg_prompt_url=$(
  cat <<MSG
Your Git repository URL (i.e.
    https://githost.example/organisation/openfisca-jurisdiction):
MSG
)
declare -xr MSG_PROMPT_URL="${_msg_prompt_url}"

# Define the message whether to continue or not.
_msg_prompt_continue=$(
  cat <<MSG
Would you like to continue (type Y for yes, N for no):
MSG
)
declare -xr MSG_PROMPT_CONTINUE="${_msg_prompt_continue}"
