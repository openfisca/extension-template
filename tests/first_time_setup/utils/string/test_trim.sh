#!/bin/bash

# @nodoc
function set_up() {
  source 'src/first_time_setup/utils/string.sh'
}

# @nodoc
function test_trim() {
  actual=$(string::trim 'Paris')
  assert_same 'Paris' "${actual}"
}

# @nodoc
function test_trim_with_accented_characters() {
  actual=$(string::trim 'Valparaíso')
  assert_same 'Valparaíso' "${actual}"
}

# @nodoc
function test_trim_with_spaces() {
  actual=$(string::trim 'New York')
  assert_same 'New_York' "${actual}"
}

# @nodoc
function test_trim_with_special_characters() {
  actual=$(string::trim 'Wellington & Suburbs')
  assert_same 'Wellington_&_Suburbs' "${actual}"
}

# @nodoc
function test_trim_with_hyphens() {
  actual=$(string::trim "L'Île-d'Yeu")
  assert_same "L'Île-d'Yeu" "${actual}"
}
