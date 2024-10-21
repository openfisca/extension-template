#!/bin/bash
# @name envvars
# @brief A package for setting the environment variables.

# The name of the jurisdiction, e.g. "United Kingdom", "Paris", etc.
declare -xr JURISDICTION_NAME=${JURISDICTION_NAME:-}

# The URL of the repository, e.g. "https://git.paris.fr/openfisca/paris"
declare -xr REPOSITORY_URL=${REPOSITORY_URL:-}

# Whether we are in a CI environment.
declare -xr CI=${CI:-}

# Dry-run mode.
declare -xr DRY_RUN=${DRY_RUN:-'false'}
