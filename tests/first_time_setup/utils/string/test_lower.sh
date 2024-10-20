#!/bin/bash

# @nodoc
function set_up() {
  source 'src/first_time_setup/utils/string.sh'
}

# @nodoc
function test_lower() {
  actual=$(string::lower 'Paris')
  assert_same 'paris' "${actual}"
}

# @nodoc
function test_lower_with_accented_characters() {
  actual=$(string::lower 'Valparaíso')
  assert_same 'valparaíso' "${actual}"
}

# @nodoc
function test_lower_with_spaces() {
  actual=$(string::lower 'New York')
  assert_same 'new york' "${actual}"
}

# @nodoc
function test_lower_with_special_characters() {
  actual=$(string::lower 'Wellington & Suburbs')
  assert_same 'wellington & suburbs' "${actual}"
}

# @nodoc
function test_lower_with_hyphens() {
  actual=$(string::lower "L'Île-d'Yeu")
  assert_same "l'île-d'yeu" "${actual}"
}
