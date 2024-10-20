#!/bin/bash

# @nodoc
function set_up() {
  source 'src/first_time_setup/utils/colours.sh'
}

# @nodoc
function test_colour_task() {
  actual=$(colour::task 'Task')
  assert_contains "Task" "${actual}"
}

# @nodoc
function test_colour_user() {
  actual=$(colour::user 'User')
  assert_contains 'User' "${actual}"
}

# @nodoc
function test_colour_pass() {
  actual=$(colour::pass 'Pass')
  assert_contains 'Pass' "${actual}"
}

# @nodoc
function test_colour_warn() {
  actual=$(colour::warn 'Warn')
  assert_contains 'Warn' "${actual}"
}

# @nodoc
function test_colour_fail() {
  actual=$(colour::fail 'Fail')
  assert_contains 'Fail' "${actual}"
}

# @nodoc
function test_colour_done() {
  actual=$(colour::done 'Done')
  assert_contains 'Done' "${actual}"
}

# @nodoc
function test_colour_info() {
  actual=$(colour::info 'Info')
  assert_contains 'Info' "${actual}"
}
