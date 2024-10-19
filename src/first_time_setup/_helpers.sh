#!/usr/bin/env bash

# Check if the script is being executed and not sourced.
if ! (return 0 2>/dev/null); then
  echo "This script should be sourced, not executed."
  exit 1
fi

# Print an error message and exit.
function helpers::error_and_exit() {
  echo "You need to provide an input value."
  exit 2
}

# Convert a string to lowercase.
function helpers::lowercase() {
  local input
  local result
  input="${1:-}"
  [[ -z $input ]] && helpers::error_and_exit
  result=$(echo "$input" | tr '[:upper:]' '[:lower:]' | sed 'y/āáǎàâäēéěèêëīíǐìîïōóǒòôöūúǔùǖǘǚǜûüĀÁǍÀÂÄĒÉĚÈÊËĪÍǏÌÎÏŌÓǑÒÔÖŪÚǓÙǕǗǙǛÛÜ/aaaaaaeeeeeeiiiiiioooooouuuuuuuuuuAAAAAAEEEEEEIIIIIIOOOOOOUUUUUUUUUU/')
  echo "$result"
}

# Remove apostrophes from a string.
function helpers::remove_apostrophes() {
  local input
  local result
  input="${1:-}"
  [[ -z $input ]] && helpers::error_and_exit
  # shellcheck disable=SC1112
  result=$(echo "$input" | sed -r 's/[\"'\''«»‘’“”„‟‹›]+/-/g')
  echo "$result"
}

# Remove special characters from a string.
function helpers::remove_special_characters() {
  local input
  local result
  input="${1:-}"
  [[ -z $input ]] && helpers::error_and_exit
  result=$(echo "$input" | sed -r 's/[^a-zA-Z _-]+//g')
  echo "$result"
}

# Remove spaces from a string.
function helpers::remove_spaces() {
  local input
  local result
  input="${1:-}"
  [[ -z $input ]] && helpers::error_and_exit
  result=$(echo "$input" | sed -r 's/[ ]+/_/g')
  echo "$result"
}

# Convert a string to snake case.
function helpers::snake_case() {
  local input
  local result
  input="${1:-}"
  [[ -z $input ]] && helpers::error_and_exit
  result=$(echo "$input" | sed -r 's/[-]+/_/g')
  echo "$result"
}
