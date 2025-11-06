#!/usr/bin/env bash

. "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/../src/messages.sh"
. "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/../src/header.sh"
. "${BPKG_DEPS:-$(cd "$(dirname "${BASH_SOURCE[0]}")/../deps" && pwd)}/tui-testkit/src/bashunit-compatible.sh"

function test_basic_color_message_functions() {
	set_test_title "Basic color message functions"

	assert_match_snapshot "$({

print_pass "All tests passed successfully"
print_fail "Test suite failed with errors"
print_warn "Deprecated function will be removed"
print_inform "Server is running on port 3000"

	} | tee >(cat >&2))"
}

function test_custom_status_labels() {
	set_test_title "Custom status labels"

	assert_match_snapshot "$({

print_pass "Build completed" "BUILD"
print_fail "Connection timeout" "ERROR"
print_warn "Memory usage high" "ALERT"
print_inform "New version available" "NOTE"

	} | tee >(cat >&2))"
}

function test_long_messages() {
	set_test_title "Long messages"

	assert_match_snapshot "$({

print_pass "This is a very long success message that demonstrates how the function handles extended text content with multiple words and detailed information"
print_fail "This is a very long failure message that demonstrates how the function handles extended text content with multiple words and detailed information"
print_warn "This is a very long warning message that demonstrates how the function handles extended text content with multiple words and detailed information"
print_inform "This is a very long informational message that demonstrates how the function handles extended text content with multiple words and detailed information"

	} | tee >(cat >&2))"
}

function test_empty_messages() {
	set_test_title "Empty messages"

	assert_match_snapshot "$({

print_pass ""
print_fail ""
print_warn ""
print_inform ""

	} | tee >(cat >&2))"
}

function test_messages_with_special_characters() {
	set_test_title "Messages with special characters"

	assert_match_snapshot "$({

print_pass "Test: 100% complete! ✓"
print_fail "Error: File not found @ /path/to/file"
print_warn "Warning: Usage > 90% (critical)"
print_inform "Info: User #123 logged in"

	} | tee >(cat >&2))"
}

function test_mixed_status_labels() {
	set_test_title "Mixed status labels (short and long)"

	assert_match_snapshot "$({

print_pass "Quick test" "OK"
print_fail "Authentication failed" "UNAUTHORIZED"
print_warn "Disk space low" "⚠ "
print_inform "Processing..." "PROCESSING"

	} | tee >(cat >&2))"
}

function test_consecutive_messages() {
	set_test_title "Consecutive messages (no spacing)"

	assert_match_snapshot "$({

print_pass "Step 1 complete"
print_pass "Step 2 complete"
print_pass "Step 3 complete"
print_fail "Step 4 failed"
print_warn "Step 5 skipped"
print_inform "Step 6 pending"

	} | tee >(cat >&2))"
}

function test_all_four_functions_in_sequence() {
	set_test_title "All four functions in sequence"

	assert_match_snapshot "$({

print_pass "Database connection established"
print_fail "Cache server unreachable"
print_warn "SSL certificate expires in 7 days"
print_inform "Running in development mode"

	} | tee >(cat >&2))"
}

function test_using_status_flag() {
	set_test_title "Using --status flag"

	assert_match_snapshot "$({

print_pass "All tests passed" --status "OK"
print_fail "Tests failed" --status "ERR"
print_warn "Some warnings" -s "ATTN"
print_inform "Information" -s "NOTE"

	} | tee >(cat >&2))"
}

function test_combining_n_with_status() {
	set_test_title "Combining -n with --status"

	assert_match_snapshot "$({

print_pass -n "No newline" --status "YAY"
echo " <- same line"
print_fail -n "Error" -s "ERR"
echo " <- same line"

	} | tee >(cat >&2))"
}

function test_flag_takes_precedence_over_positional() {
	set_test_title "Flag takes precedence over positional"

	assert_match_snapshot "$({

print_pass "Message" "WRONG" --status "RIGHT"
print_fail "Message" "WRONG" -s "RIGHT"

	} | tee >(cat >&2))"
}

function test_using_padding_flag() {
	set_test_title "Using --padding flag"

	assert_match_snapshot "$({

print_pass "PASSED" --padding 3
print_fail "FAILED" "X" -p 0
print_inform # No Message defaults to no padding

	} | tee >(cat >&2))"
}

run_tests -h "$(print_header -b $'\033[0;31m\033[1m' -t $'\033[0;33m\033[1m' "{name}")\n"

