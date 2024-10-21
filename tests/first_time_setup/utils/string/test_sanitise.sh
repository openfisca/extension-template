#!/bin/bash

# @nodoc
function set_up() {
  source 'src/first_time_setup/utils/string.sh'
}

# @nodoc
function test_sanitise() {
  actual=$(string::sanitise 'Paris')
  assert_same 'Paris' "${actual}"
}

# @nodoc
function test_sanitise_with_accented_characters() {
  actual=$(string::sanitise 'Valparaíso')
  assert_same 'Valparaíso' "${actual}"
}

# @nodoc
function test_sanitise_with_spaces() {
  actual=$(string::sanitise 'New York')
  assert_same 'New York' "${actual}"
}

# @nodoc
function test_sanitise_with_special_characters() {
  actual=$(string::sanitise 'Wellington & Suburbs')
  assert_same 'Wellington  Suburbs' "${actual}"
}

# @nodoc
function test_sanitise_with_hyphens() {
  actual=$(string::sanitise "L'Île-d'Yeu")
  assert_same "L-Île-d-Yeu" "${actual}"
}
