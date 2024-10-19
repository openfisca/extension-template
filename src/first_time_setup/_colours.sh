#!/usr/bin/env bash

# Check if the script is being executed and not sourced.
if ! (return 0 2>/dev/null); then
  echo "This script should be sourced, not executed."
  exit 1
fi

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
