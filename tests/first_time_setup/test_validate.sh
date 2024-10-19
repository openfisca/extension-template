#!/usr/bin/env bash

set -o errexit

function set_up() {
  source ./src/first_time_setup/_validate.sh
}

function test_validate_repo() {
  export CI=true
  mock git false
  validate::repo
  assert_exit_code 0
}

function test_validate_repo_when_not_in_ci() {
  export CI=false
  mock git false
  validate::repo
  assert_exit_code 0
}

function test_validate_repo_when_repo_exists() {
  export CI="yes"
  mock git true
  validate::repo
  assert_exit_code 0
}

function test_validate_repo_when_not_in_ci_and_repo_exists() {
  export CI=""
  mock git true
  actual=$(validate::repo)
  assert_exit_code 2
  assert_contains "It seems you cloned this repositorsy" "$actual"
}
