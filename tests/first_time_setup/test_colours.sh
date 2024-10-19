set -o errexit

function set_up() {
  source ./src/first_time_setup/_colours.sh
}

function test_colours_task() {
  actual=$(colours::task "Task")
  assert_contains "Task" "$actual"
}

function test_colours_user() {
  actual=$(colours::user "User")
  assert_contains "User" "$actual"
}

function test_colours_pass() {
  actual=$(colours::pass "Pass")
  assert_contains "Pass" "$actual"
}

function test_colours_warn() {
  actual=$(colours::warn "Warn")
  assert_contains "Warn" "$actual"
}

function test_colours_fail() {
  actual=$(colours::fail "Fail")
  assert_contains "Fail" "$actual"
}

function test_colours_done() {
  actual=$(colours::done "Done")
  assert_contains "Done" "$actual"
}

function test_colours_info() {
  actual=$(colours::info "Info")
  assert_contains "Info" "$actual"
}
