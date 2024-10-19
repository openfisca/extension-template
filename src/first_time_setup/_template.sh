#!/usr/bin/env bash

# Check if the script is being executed and not sourced.
if ! (return 0 2>/dev/null); then
  echo "This script should be sourced, not executed."
  exit 1
fi

# Set the root directory where the script is located.
_ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
declare -r ROOT_DIR="${_ROOT_DIR}"

source "$ROOT_DIR/src/first_time_setup/_checks.sh"
source "$ROOT_DIR/src/first_time_setup/_colours.sh"
source "$ROOT_DIR/src/first_time_setup/_envvars.sh"
source "$ROOT_DIR/src/first_time_setup/_helpers.sh"
source "$ROOT_DIR/src/first_time_setup/_validate.sh"
source "$ROOT_DIR/src/first_time_setup/_version.sh"

function main() {
  local non_interactive=$1
  local we_are_in_ci=$2
  local repo_exists=$3
  local continue
  # Check if the script should run in non-interactive mode.
  continue=$([ "$non_interactive" == "true" ] && echo "y" || echo "n")
}

# Call the main function to bootstrap the package.
main "$(checks::non_interactive)" "$(checks::we_are_in_ci)" "$(checks::repo_exists)"
