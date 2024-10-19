#!/usr/bin/env bash

set -o errexit

function set_up() {
  source ./src/first_time_setup/_helpers.sh
}

function test_helpers_lowercase() {
  actual=$(helpers::lowercase "Paris")
  assert_same "paris" "$actual"
}

function test_helpers_lowercase_with_accented_characters() {
  actual=$(helpers::lowercase "Valparaíso")
  assert_same "valparaiso" "$actual"
}

function test_helpers_lowercase_with_spaces() {
  actual=$(helpers::lowercase "New York")
  assert_same "new york" "$actual"
}

function test_helpers_lowercase_with_special_characters() {
  actual=$(helpers::lowercase "Wellington & Suburbs")
  assert_same "wellington & suburbs" "$actual"
}

function test_helpers_lowercase_with_hyphens() {
  actual=$(helpers::lowercase "L'Île-d'Yeu")
  assert_same "l'ile-d'yeu" "$actual"
}

function test_helpers_lowercase_when_empty() {
  actual=$(helpers::lowercase "")
  assert_exit_code 2
  assert_same "You need to provide an input value." "$actual"
}

function test_helpers_lowercase_when_not_provided() {
  actual=$(helpers::lowercase)
  assert_exit_code 2
  assert_same "You need to provide an input value." "$actual"
}
