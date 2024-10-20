#!/bin/bash

# @nodoc
function set_up() {
  source 'src/first_time_setup/utils/string.sh'
}

# @nodoc
function test_decode() {
  actual=$(string::decode 'Paris')
  assert_same 'Paris' "${actual}"
}

# @nodoc
function test_decode_with_accented_characters() {
  actual=$(string::decode 'Valparaíso')
  assert_same 'Valparaiso' "${actual}"
}

# @nodoc
function test_decode_with_spaces() {
  actual=$(string::decode 'New York')
  assert_same 'New York' "${actual}"
}

# @nodoc
function test_decode_with_special_characters() {
  actual=$(string::decode 'Wellington & Suburbs')
  assert_same 'Wellington & Suburbs' "${actual}"
}

# @nodoc
function test_decode_with_hyphens() {
  actual=$(string::decode "L'Île-d'Yeu")
  assert_same "L'Ile-d'Yeu" "${actual}"
}
