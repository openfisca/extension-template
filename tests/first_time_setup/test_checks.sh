#!/usr/bin/env bash

set -o errexit

function set_up() {
  source ./src/first_time_setup/_checks.sh
}

function test_checks_non_interactive() {
  export JURISDICTION_NAME="Paris"
  export REPOSITORY_URL="https://git.paris.fr/openfisca/paris"
  actual=$(checks::non_interactive)
  assert_true "$actual"
}

function test_checks_non_interactive_when_name_is_not_set() {
  unset JURISDICTION_NAME
  export REPOSITORY_URL="https://git.paris.fr/openfisca/paris"
  actual=$(checks::non_interactive)
  assert_false "$actual"
}

function test_checks_non_interactive_when_url_is_not_set() {
  export JURISDICTION_NAME="Paris"
  unset REPOSITORY_URL
  actual=$(checks::non_interactive)
  assert_false "$actual"
}

function test_checks_non_interactive_when_both_are_not_set() {
  unset JURISDICTION_NAME
  unset REPOSITORY_URL
  actual=$(checks::non_interactive)
  assert_false "$actual"
}

function test_checks_we_are_in_ci() {
  export CI="true"
  actual=$(checks::we_are_in_ci)
  assert_true "$actual"
}

function test_checks_we_are_in_ci_when_set_to_false() {
  export CI=false
  actual=$(checks::we_are_in_ci)
  assert_false "$actual"
}

function test_checks_we_are_in_ci_when_set_to_zero() {
  export CI=0
  actual=$(checks::we_are_in_ci)
  assert_false "$actual"
}

function test_checks_we_are_in_ci_when_empty() {
  export CI=""
  actual=$(checks::we_are_in_ci)
  assert_false "$actual"
}

function test_checks_we_are_in_ci_when_null() {
  export CI=
  actual=$(checks::we_are_in_ci)
  assert_false "$actual"
}

function test_checks_we_are_in_ci_when_not_set() {
  unset CI
  actual=$(checks::we_are_in_ci)
  assert_false "$actual"
}

function test_checks_repo_exists() {
  mock git true
  actual=$(checks::repo_exists)
  assert_true "$actual"
}

function test_checks_repo_exists_when_it_does_not() {
  mock git false
  actual=$(checks::repo_exists)
  assert_false "$actual"
}
