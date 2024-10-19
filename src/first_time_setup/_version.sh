#!/usr/bin/env bash

# Check if the script is being executed and not sourced.
if ! (return 0 2>/dev/null); then
  echo "This script should be sourced, not executed."
  exit 1
fi

# Set the current version of this template.
declare -r VERSION="X.X.X"

# Export the version.
export VERSION
