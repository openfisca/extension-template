#!/usr/bin/env bash

# Check if the script is being executed and not sourced.
if ! (return 0 2>/dev/null); then
  echo "This script should be sourced, not executed."
  exit 1
fi

# Define a function to print a message when a task starts.
function colours::task() {
  echo "$(tput setaf 5)[⚙]$(tput sgr0) $1"
}

# Define a function to print a message when a asking for input.
function colours::user() {
  echo "$(tput setaf 4)[❯]$(tput sgr0) $1"
}

# Define a function to print a message when a task passes.
function colours::pass() {
  echo "$(tput setaf 6)[λ]$(tput sgr0) $1"
}

# Define a function to print a message with a warning.
function colours::warn() {
  echo "$(tput setaf 3)[!]$(tput sgr0) $1"
}

# Define a function to print a message when a task fails.
function colours::fail() {
  echo "$(tput setaf 1)[x]$(tput sgr0) $1"
}

# Define a function to print a message when a task finishes.
function colours::done() {
  echo "$(tput setaf 2)[✓]$(tput sgr0) $1"
}

# Define a function to print an info message (for example, an interruption).
function colours::info() {
  echo "$(tput setaf 7)[i]$(tput sgr0) $1"
}
