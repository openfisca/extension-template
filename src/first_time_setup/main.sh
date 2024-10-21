#!/bin/bash
# @name main
# @deps checks envvars messages setup status utils/*
# @brief Setup a new OpenFisca extension package.

source 'src/first_time_setup/checks.sh'
source 'src/first_time_setup/envvars.sh'
source 'src/first_time_setup/messages.sh'
source 'src/first_time_setup/setup.sh'
source 'src/first_time_setup/status.sh'
source 'src/first_time_setup/utils/boolean.sh'
source 'src/first_time_setup/utils/colours.sh'
source 'src/first_time_setup/utils/git.sh'
source 'src/first_time_setup/utils/string.sh'
source 'src/first_time_setup/utils/subshell.sh'
source 'src/first_time_setup/utils/url.sh'

# @description Unknown error handling.
# @arg $1 The line number where the error occurred.
# @arg $2 The exit code of the command.
# @internal
::trap::unexpected() {
  local -r lineno="${1}"
  local -r exit_code="${2}"
  local -r message="Error code ${exit_code} on line ${lineno}."
  local result
  trap - ERR
  result=$(colour::fail "${message}")
  readonly result
  echo -e "${result}" >&2
  exit "${exit_code}"
}

# @description User interruption.
# @internal
::trap::interrupted() {
  local -r exit_code=$?
  local -r message="Interrupted."
  local result
  trap - SIGINT
  result=$(colour::warn "${message}")
  readonly result
  echo ""
  echo -e "${result}" >&2
  exit "${exit_code}"
}

# @description Cleanup on exit.
# @internal
::trap::cleanup() {
  local exit_code=$?
  local message="Exiting, bye!"
  local result
  trap - EXIT
  result=$(colour::info "${message}")
  readonly result
  echo -e "${result}"
  exit "${exit_code}"
}

# @description Generic error message.
# @arg $1 The message to display.
# @internal
::error() {
  local -r message="${1}"
  local result
  result=$(colour::fail "${message}")
  readonly result
  echo -e "${result}" >&2
}

# @description The actual setup function.
# @arg $1 The jurisdiction name.
# @arg $2 The jurisdiction name in snake case.
# @arg $3 If it is a dry run.
setup() {
  local -r setup_is_ci="${1}"
  local -r setup_nake="${2}"
  local -r setup_dry="${3}"
  local -r first_commit_message='Initial import from OpenFisca Extension Template'
  local -r second_commit_message='Customise OpenFisca Extension Template through script'
  local -r parent_folder=${PWD##*/}
  local -r package_name="openfisca_${setup_nake}"
  local last_bootstrapping_line_number
  local last_changelog_number

  # Support being called from anywhere on the file system
  cd "$(dirname "$0")"

  # Get the last line number of the bootstrapping section.
  last_bootstrapping_line_number=$(grep --line-number '^## Writing the Legislation' README.md | cut -d ':' -f 1)
  readonly last_bootstrapping_line_number

  # Get the last line number of the changelog section.
  last_changelog_number=$(grep --line-number '^# Example Entry' CHANGELOG.md | cut -d ':' -f 1)
  readonly last_changelog_number
}

# @description Main function to drive the script.
main() {
  local is_sourced
  local prompt_name
  local prompt_continue
  local prompt_url
  local repository_folder
  local root_dir
  local setup_continue
  local setup_dev
  local setup_dry
  local setup_is_ci
  local setup_is_int
  local setup_is_repo
  local setup_name
  local setup_name_label
  local setup_name_snake
  local setup_persevere
  local setup_url

  # Exit immediately if a command exits with a non-zero status.
  set -o errexit
  # Ensure that the ERR trap is inherited by shell functions.
  set -o errtrace
  # More verbosity when something within a function fails.
  set -o functrace
  # Treat unset variables as an error and exit immediately.
  set -o nounset
  # Prevent errors in a pipeline from being masked.
  set -o pipefail
  # Make word splitting happen only on newlines and tab characters.
  IFS=$'\n\t'

  # Define a cleanup functions to be called on script exit or interruption.
  trap '::trap::unexpected "${BASH_LINENO}" "${?}"' ERR
  trap ::trap::interrupted SIGINT
  trap ::trap::cleanup EXIT

  # Are we being sourced?
  is_sourced=$(is::sourced)
  readonly is_sourced="${is_sourced}"

  # Make sure we are not being sourced. Exit if it is the case.
  if ${is_sourced}; then
    ::error 'This script should not be sourced but executed directly.'
    exit 1
  fi

  # Set the root directory where the script is located.
  root_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

  # Check if we are running in development mode.
  setup_dev=$(is::dev "${root_dir}")
  readonly setup_dev

  # If we are in development mode, move the root directory up two levels.
  if ${setup_dev}; then root_dir=$(cd "${root_dir}/../.." && pwd); fi
  readonly root_dir

  # Get the environment variables from global to local scope.
  setup_name="${JURISDICTION_NAME}"
  setup_url="${REPOSITORY_URL}"
  setup_dry="${DRY_RUN}"

  # Can we continue in interactive mode?
  setup_is_int=$(is::interactive "${setup_name}" "${setup_url}")
  readonly setup_is_int

  # Are we in a CI environment?
  setup_is_ci=$(is::ci "${CI}")
  readonly setup_is_ci

  # Does the repository exist already?
  setup_is_repo=$(is::repo)
  readonly setup_is_repo

  # Should we persevere?
  setup_persevere="$(setup::persevere "${setup_is_ci}" "${setup_is_repo}")"
  readonly setup_persevere

  # Is it a dry run?
  setup_dry=$(is::true "${setup_dry}")
  readonly setup_dry

  # Print a welcome message.
  colour::info "${MSG_WELCOME}"

  # Gather information from environment variables.
  status::gather_info "${setup_name}" "${setup_url}" "${setup_is_int}"

  # Check if we can continue.
  status::check_continue \
    "${setup_is_ci}" \
    "${setup_is_repo}" \
    "${setup_persevere}" \
    "${setup_dry}"

  if ! ${setup_persevere} && ! ${setup_dry}; then
    echo ""
    ::error "${MSG_STOP}"
    echo ""
    exit 2
  fi

  # Print a message to let the user know we are waiting for input.
  echo ""
  colour::info "We will now start setting up your new package."

  # Ask for the jurisdiction name.
  if [[ -z ${setup_name} ]]; then echo ""; fi
  prompt_name=$(colour::user "${MSG_PROMPT_NAME}")
  while [[ -z ${setup_name} ]]; do
    echo -e -n "${prompt_name}"
    IFS= read -r -p " " setup_name
  done
  readonly setup_name

  # Remove spaces from the jurisdiction name.
  setup_name_label=$(setup::name_label "${setup_name}")
  readonly setup_name_label

  # Snake case the jurisdiction name.
  setup_name_snake=$(setup::name_snake "${setup_name_label}")
  readonly setup_name_snake

  #  # Ask for the repository URL.
  if [[ -z ${setup_url} ]]; then echo ""; fi
  prompt_url=$(colour::user "${MSG_PROMPT_URL}")
  while [[ -z ${setup_url} ]]; do
    echo -e -n "${prompt_url}"
    IFS= read -r -p " " setup_url
  done
  readonly setup_url

  # Process the repository folder.
  repository_folder=$(setup::repository_folder "${setup_url}")
  readonly repository_folder

  # Print a summary of the information gathered.
  status::pre_summary "${setup_name}" "${setup_name_snake}" "${setup_url}"

  # Shall we proceed?
  echo ""
  prompt_continue=$(colour::user "${MSG_PROMPT_CONTINUE}")
  setup_continue=$(is::false "${setup_is_int}")
  while ! ${setup_continue}; do
    echo -e -n "${prompt_continue}"
    IFS= read -r -p " " setup_continue
    setup_continue=$(is::true "${setup_continue}")
    if ! ${setup_continue}; then
      break
    fi
  done
  echo " =  ${setup_continue}"
  if ! ${setup_continue}; then
    echo ""
    exit 3
  fi

  # Now we can proceed with the setup.
  setup "${setup_is_ci}" "${setup_name_snake}" "${setup_dry}"
}

main "$@"
