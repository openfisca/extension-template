#!/usr/bin/env bash
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

# Define a cleanup function to be called on script exit or interruption.
trap cleanup SIGINT SIGTERM ERR EXIT

# Define constants for directory and file paths.
declare -r ROOT_DIR=.
declare -r TEMP_FILE="$ROOT_DIR/temp.sh"
declare -r SOURCE_DIR="$ROOT_DIR/src/first_time_setup"
declare -r TEMPLATE_FILE="$SOURCE_DIR/_template.sh"

# Define a function to print a message when a task starts.
function init() {
  echo "$(tput setaf 5)[⚙]$(tput sgr0) $1"
}
# Define a function to print a message when a task passes.
function pass() {
  echo "$(tput setaf 6)[λ]$(tput sgr0) $1"
}

# Define a function to print a message when a task finishes.
function info() {
  echo "$(tput setaf 2)[✓]$(tput sgr0) $1"
}

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
  echo -e "$(init "Building '$out'")"
  # Create a temporary file.
  create_temp_file
  # Add each script file in the source directory to the temporary file.
  for file in "$SOURCE_DIR"/*.sh; do add_file_to_temp "$file"; done
  # Apply the template to the output file.
  apply_template "$out"
  # Set the version in the output file.
  set_version "$out"
  echo -e "$(info "Building complete :)")"
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
    echo -e "$(pass "Adding $file...")"
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
  echo -e "$(pass "Setting version to $version...")"
  # Replace 'X.X.X' with the actual version in the output file.
  sed -i '' "s/X\.X\.X/$version/g" "$out"
}

# Function to clean up temporary files.
function cleanup() {
  rm -f "$TEMP_FILE"
}

# Call the main function with the argument 'first-time-setup.sh'.
main "first-time-setup.sh"
