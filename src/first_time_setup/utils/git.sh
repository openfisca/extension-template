#!/bin/bash
# @name git
# @brief A package for check git stuff.

# Exit immediately if a command exits with a non-zero status.
set -o errexit

# Treat unset variables as an error and exit immediately.
set -o nounset

# Prevent errors in a pipeline from being masked.
set -o pipefail

# @description Check if we are in a working tree
is::inside_working_tree() {
  if git rev-parse --is-inside-work-tree &>/dev/null; then echo true; fi
  echo false
}
