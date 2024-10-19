#!/usr/bin/env bash

if (return 0 2>/dev/null); then
  echo "This script should be executed, not sourced."
  exit 1
else
  # Exit immediately if a command exits with a non-zero status.
  set -o errexit
  # Ensure that the ERR trap is inherited by shell functions.
  set -o errtrace
  # Treat unset variables as an error and exit immediately.
  set -o nounset
  # Prevent errors in a pipeline from being masked.
  set -o pipefail
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

# Set the colours for the script.
declare -r GREEN="\033[0;32m"
declare -r PURPLE="\033[1;35m"
declare -r YELLOW="\033[0;33m"
declare -r BLUE="\033[1;34m"

# Export the colours.
export GREEN
export PURPLE
export YELLOW
export BLUE

# The name of the jurisdiction, e.g. "United Kingdom", "Paris", etc.
declare -r JURISDICTION_NAME=${JURISDICTION_NAME:-}
# The URL of the repository, e.g. "https://git.paris.fr/openfisca/paris"
declare -r REPOSITORY_URL=${REPOSITORY_URL:-}
# Whether we are in a CI environment.
declare -r CI=${CI:-}

# Export the variables.
export JURISDICTION_NAME
export REPOSITORY_URL
export CI

# Print an error message and exit.
function helpers::error_and_exit() {
  echo "You need to provide an input value."
  exit 2
}

# Convert a string to lowercase.
function helpers::lowercase() {
  local input
  local result
  input="${1:-}"
  [ -z "$input" ] && helpers::error_and_exit
  result=$(echo "$input" | tr '[:upper:]' '[:lower:]' | sed 'y/āáǎàâäēéěèêëīíǐìîïōóǒòôöūúǔùǖǘǚǜûüĀÁǍÀÂÄĒÉĚÈÊËĪÍǏÌÎÏŌÓǑÒÔÖŪÚǓÙǕǗǙǛÛÜ/aaaaaaeeeeeeiiiiiioooooouuuuuuuuuuAAAAAAEEEEEEIIIIIIOOOOOOUUUUUUUUUU/')
  echo "$result"
}

# Remove apostrophes from a string.
function helpers::remove_apostrophes() {
  local input
  local result
  input="${1:-}"
  [ -z "$input" ] && helpers::error_and_exit
  # shellcheck disable=SC1112
  result=$(echo "$input" | sed -r 's/[\"'\''«»‘’“”„‟‹›]+/-/g')
  echo "$result"
}

# Remove special characters from a string.
function helpers::remove_special_characters() {
  local input
  local result
  input="${1:-}"
  [ -z "$input" ] && helpers::error_and_exit
  result=$(echo "$input" | sed -r 's/[^a-zA-Z _-]+//g')
  echo "$result"
}

# Remove spaces from a string.
function helpers::remove_spaces() {
  local input
  local result
  input="${1:-}"
  [ -z "$input" ] && helpers::error_and_exit
  result=$(echo "$input" | sed -r 's/[ ]+/_/g')
  echo "$result"
}

# Convert a string to snake case.
function helpers::snake_case() {
  local input
  local result
  input="${1:-}"
  [ -z "$input" ] && helpers::error_and_exit
  result=$(echo "$input" | sed -r 's/[-]+/_/g')
  echo "$result"
}

# Check if the functions are already defined.
if [ -z "$(checks::we_are_in_ci)" ] || [ -z "$(checks::repo_exists)" ]; then
  # Set the root directory where this script is located.
  VALIDATE_DIR="$(dirname "${BASH_SOURCE[0]}")"

  # Source the script with the required functions.
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

# Set the current version of this template.
declare -r VERSION="2.0.0"

# Export the version.
export VERSION

# Set the root directory where the script is located.
_ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
declare -r ROOT_DIR="${_ROOT_DIR}"

function main() {
  local non_interactive=$1
  local we_are_in_ci=$2
  local repo_exists=$3
  local continue
  # Check if the script should run in non-interactive mode.
  continue=$([ "$non_interactive" == "true" ] && echo "y" || echo "n")

  echo "$(validate::repo)"
  echo "$ROOT_DIR"

}

# Call the main function to bootstrap the package.
main "$(checks::non_interactive)" "$(checks::we_are_in_ci)" "$(checks::repo_exists)"
