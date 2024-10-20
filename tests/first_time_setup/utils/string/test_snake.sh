#!/bin/bash

# @nodoc
function set_up() {
  source 'src/first_time_setup/utils/string.sh'
}

# @nodoc
function test_snake() {
  actual=$(string::snake 'Paris')
  assert_same 'Paris' "${actual}"
}

# @nodoc
function test_snake_with_accented_characters() {
  actual=$(string::snake 'Valparaíso')
  assert_same 'Valparaíso' "${actual}"
}

# @nodoc
function test_snake_with_spaces() {
  actual=$(string::snake 'New York')
  assert_same 'New York' "${actual}"
}

# @nodoc
function test_snake_with_special_characters() {
  actual=$(string::snake 'Wellington & Suburbs')
  assert_same 'Wellington & Suburbs' "${actual}"
}

# @nodoc
function test_snake_with_hyphens() {
  actual=$(string::snake "L'Île-d'Yeu")
  assert_same "L'Île_d'Yeu" "${actual}"
}
