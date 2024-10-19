#!/usr/bin/env bash

set -o errexit

function set_up() {
  source ./src/first_time_setup/_helpers.sh
}

function test_helpers_remove_apostrophes() {
  actual=$(helpers::remove_apostrophes "Paris")
  assert_same "Paris" "$actual"
}

function test_helpers_remove_apostrophes_with_accented_characters() {
  actual=$(helpers::remove_apostrophes "Valparaíso")
  assert_same "Valparaíso" "$actual"
}

function test_helpers_remove_apostrophes_with_spaces() {
  actual=$(helpers::remove_apostrophes "New York")
  assert_same "New York" "$actual"
}

function test_helpers_remove_apostrophes_with_special_characters() {
  actual=$(helpers::remove_apostrophes "Wellington & Suburbs")
  assert_same "Wellington & Suburbs" "$actual"
}

function test_helpers_remove_apostrophes_with_hyphens() {
  actual=$(helpers::remove_apostrophes "L'Île-d'Yeu")
  assert_same "L-Île-d-Yeu" "$actual"
}

function test_helpers_remove_apostrophes_when_empty() {
  actual=$(helpers::remove_apostrophes "")
  assert_exit_code 2
  assert_same "You need to provide an input value." "$actual"
}

function test_helpers_remove_apostrophes_when_not_provided() {
  actual=$(helpers::remove_apostrophes)
  assert_exit_code 2
  assert_same "You need to provide an input value." "$actual"
}
