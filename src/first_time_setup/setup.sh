#!/bin/bash
# @name setup
# @deps utils/string utils/url
# @brief Functions for setting up the new package.

# Exit immediately if a command exits with a non-zero status.
set -o errexit

# Treat unset variables as an error and exit immediately.
set -o nounset

# Prevent errors in a pipeline from being masked.
set -o pipefail

source 'src/first_time_setup/utils/string.sh'
source 'src/first_time_setup/utils/url.sh'

# @description Set up the jurisdiction name label
# @arg $1 The jurisdiction name.
setup::name_label() {
  local -r setup_name="${1}"
  local setup_name_label
  setup_name_label=$(string::lower "${setup_name}")
  setup_name_label=$(string::decode "${setup_name_label}")
  setup_name_label=$(string::sanitise "${setup_name_label}")
  setup_name_label=$(string::trim "${setup_name_label}")
  readonly setup_name_label
  echo "${setup_name_label}"
}

# @description Snake case the jurisdiction name.
# @arg $1 The jurisdiction name label.
setup::name_snake() {
  local -r setup_name_label="${1}"
  local setup_name_snake
  setup_name_snake=$(string::snake "${setup_name_label}")
  readonly setup_name_snake
  echo "${setup_name_snake}"
}

# @description Get the repository folder.
# @arg $1 The repository URL.
setup::repository_folder() {
  local -r setup_url="${1}"
  local repository_folder
  repository_folder=$(url::folder "${setup_url}")
  readonly repository_folder
  echo "${repository_folder}"
}
