#!/bin/bash
#
# This file:
#
#     Builds the script required for the first-time setup of a new OpenFisca
#     country or extension package.
#
# Usage:
#
#     ./scripts/build.sh
#
# Based on the original script from the OpenFisca Country Template:
# https://github.com/openfisca/country-template/blob/5c33a5c0930d3ee83544b9f4d6a7d84b2f39d8c3/first-time-setup.sh

# Exit immediately if a command exits with a non-zero status.
set -o errexit
# Ensure that the ERR trap is inherited by shell functions.
set -o errtrace
# Treat unset variables as an error and exit immediately.
set -o nounset
# Prevent errors in a pipeline from being masked.
set -o pipefail

# Define a cleanup functions to be called on script exit or interruption.
trap 'unexpected_error $? $LINENO' ERR
trap interruped SIGINT
trap cleanup EXIT

# Define constants for directory and file paths.
declare -r ROOT_DIR=.
declare -r TEMP_FILE="$ROOT_DIR/temp.sh"
declare -r SOURCE_DIR="$ROOT_DIR/src/first_time_setup"
declare -r TEMPLATE_FILE="$SOURCE_DIR/main.sh"

# Source the colours script.
source "$SOURCE_DIR/_colours.sh"

# Main function to drive the script.
function main() {
  # Change to the script's parent directory.
  cd "$(dirname "$0")/.."
  # Call the build function with the first argument.
  build "$1"
  # Call the cleanup function.
  cleanup
}

# Function to build the output file.
function build() {
  local out=$1
  echo -e "$(colours::task "Building '$out'")"
  # Create a temporary file.
  create_temp_file
  # Add each script file in the source directory to the temporary file.
  echo -e "$(colours::task "Adding files...")"
  for file in "$SOURCE_DIR"/*.sh; do add_file_to_temp "$file"; done
  echo -e "$(colours::done "Files added...")"
  # Apply the template to the output file.
  echo -e "$(colours::task "Applying template...")"
  apply_template "$out"
  echo -e "$(colours::done "Template applied...")"
  # Set the version in the output file.
  echo -e "$(colours::task "Setting version...")"
  set_version "$out"
  echo -e "$(colours::done "Version set...")"
  echo -e "$(colours::done "Building complete :)")"
}

# Function to create the initial temporary file.
function create_temp_file() {
  {
    echo "#!/usr/bin/env bash"
    echo ""
    echo "if (return 0 2>/dev/null); then"
    echo '  echo "This script should be executed, not sourced."'
    echo "  exit 1"
    echo "else"
    echo "  # Exit immediately if a command exits with a non-zero status."
    echo "  set -o errexit"
    echo "  # Ensure that the ERR trap is inherited by shell functions."
    echo "  set -o errtrace"
    echo "  # Treat unset variables as an error and exit immediately."
    echo "  set -o nounset"
    echo "  # Prevent errors in a pipeline from being masked."
    echo "  set -o pipefail"
    echo "fi"
  } >"$TEMP_FILE"
}

# Function to add a file's content to the temporary file.
function add_file_to_temp() {
  local file=$1
  if [ "$file" != "$TEMPLATE_FILE" ]; then
    echo -e "$(colours::pass "Adding $file...")"
    # Append the content of the file, starting from the 8th line, to the
    # temporary file.
    tail -n +8 "$file" >>"$TEMP_FILE"
  fi
}

# Function to apply the template to the output file.
function apply_template() {
  local out=$1
  # Append the content of the template file, starting from the 8th line, to
  # the temporary file.
  tail -n +8 "$TEMPLATE_FILE" >>"$TEMP_FILE"
  # Remove lines starting with 'source' and write the result to the output
  # file.
  grep -v '^source' "$TEMP_FILE" >"$out"
  # Make the output file executable.
  chmod u+x "$out"
}

# Function to set the version in the output file.
function set_version() {
  local out=$1
  local version
  # Get the version from poetry.
  version=$(poetry version --short)
  echo -e "$(colours::info "Setting version to $version...")"
  # Replace 'X.X.X' with the actual version in the output file.
  sed -i '' "s/X\.X\.X/$version/g" "$out"
}

# Error handling.
function unexpected_error() {
  trap - ERR
  echo -e "$(colours::fail "Error $1 on line $2.")"
}

# Error handling.
function interrupted() {
  trap - ERR
  echo ""
  echo -e "$(colours::warn "Interrupted.")"
}

# Function to clean up the temporary file.
function cleanup() {
  trap - EXIT
  echo -e "$(colours::info "Cleaning up.")"
  rm -f "$TEMP_FILE"
}

# Call the main function with the argument 'first-time-setup.sh'.
main "first-time-setup.sh"
