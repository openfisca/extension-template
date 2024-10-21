#!/bin/bash
# @name utils/url
# @brief A package to extract infor from a URL

# Exit immediately if a command exits with a non-zero status.
set -o errexit

# Treat unset variables as an error and exit immediately.
set -o nounset

# Prevent errors in a pipeline from being masked.
set -o pipefail

# @description Get the folder from a URL
# @arg $1 The URL
url::folder() {
  local -r url="${1}"
  local -r clean_url="${url%%[\?#]*}"
  local -r trimmed_url="${clean_url%/}"
  local -r folder="${trimmed_url##*/}"
  echo "${folder}"
}
