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

function test_helpers_remove_special_characters() {
  actual=$(helpers::remove_special_characters "Paris")
  assert_same "Paris" "$actual"
}

function test_helpers_remove_special_characters_with_accented_characters() {
  actual=$(helpers::remove_special_characters "Valparaíso")
  assert_same "Valparaíso" "$actual"
}

function test_helpers_remove_special_characters_with_spaces() {
  actual=$(helpers::remove_special_characters "New York")
  assert_same "New York" "$actual"
}

function test_helpers_remove_special_characters_with_special_characters() {
  actual=$(helpers::remove_special_characters "Wellington & Suburbs")
  assert_same "Wellington  Suburbs" "$actual"
}

function test_helpers_remove_special_characters_with_hyphens() {
  actual=$(helpers::remove_special_characters "L'Île-d'Yeu")
  assert_same "LÎle-dYeu" "$actual"
}

function test_helpers_remove_special_characters_when_empty() {
  actual=$(helpers::remove_special_characters "")
  assert_exit_code 2
  assert_same "You need to provide an input value." "$actual"
}

function test_helpers_remove_special_characters_when_not_provided() {
  actual=$(helpers::remove_special_characters)
  assert_exit_code 2
  assert_same "You need to provide an input value." "$actual"
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
