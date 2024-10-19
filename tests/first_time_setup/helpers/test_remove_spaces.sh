#!/usr/bin/env bash

set -o errexit

function set_up() {
  source ./src/first_time_setup/_helpers.sh
}

function test_helpers_remove_spaces() {
  actual=$(helpers::remove_spaces "Paris")
  assert_same "Paris" "$actual"
}

function test_helpers_remove_spaces_with_accented_characters() {
  actual=$(helpers::remove_spaces "Valparaíso")
  assert_same "Valparaíso" "$actual"
}

function test_helpers_remove_spaces_with_spaces() {
  actual=$(helpers::remove_spaces "New York")
  assert_same "New_York" "$actual"
}

function test_helpers_remove_spaces_with_special_characters() {
  actual=$(helpers::remove_spaces "Wellington & Suburbs")
  assert_same "Wellington_&_Suburbs" "$actual"
}

function test_helpers_remove_spaces_with_hyphens() {
  actual=$(helpers::remove_spaces "L'Île-d'Yeu")
  assert_same "L'Île-d'Yeu" "$actual"
}

function test_helpers_remove_spaces_when_empty() {
  actual=$(helpers::remove_spaces "")
  assert_exit_code 2
  assert_same "You need to provide an input value." "$actual"
}

function test_helpers_remove_spaces_when_not_provided() {
  actual=$(helpers::remove_spaces)
  assert_exit_code 2
  assert_same "You need to provide an input value." "$actual"
}
