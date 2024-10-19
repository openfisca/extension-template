#!/usr/bin/env bash

set -o errexit

function set_up() {
  source ./src/first_time_setup/_helpers.sh
}

function test_helpers_snake_case() {
  actual=$(helpers::snake_case "Paris")
  assert_same "Paris" "$actual"
}

function test_helpers_snake_case_with_accented_characters() {
  actual=$(helpers::snake_case "Valparaíso")
  assert_same "Valparaíso" "$actual"
}

function test_helpers_snake_case_with_spaces() {
  actual=$(helpers::snake_case "New York")
  assert_same "New York" "$actual"
}

function test_helpers_snake_case_with_special_characters() {
  actual=$(helpers::snake_case "Wellington & Suburbs")
  assert_same "Wellington & Suburbs" "$actual"
}

function test_helpers_snake_case_with_hyphens() {
  actual=$(helpers::snake_case "L'Île-d'Yeu")
  assert_same "L'Île_d'Yeu" "$actual"
}

function test_helpers_snake_case_when_empty() {
  actual=$(helpers::snake_case "")
  assert_exit_code 2
  assert_same "You need to provide an input value." "$actual"
}

function test_helpers_snake_case_when_not_provided() {
  actual=$(helpers::snake_case)
  assert_exit_code 2
  assert_same "You need to provide an input value." "$actual"
}
