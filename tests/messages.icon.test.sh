#!/usr/bin/env bash

. "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/../src/messages.sh"
. "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/../src/header.sh"
. "${BPKG_DEPS:-$(cd "$(dirname "${BASH_SOURCE[0]}")/../deps" && pwd)}/tui-testkit/src/bashunit-compatible.sh"

function test_basic_icon_message_functions() {
	set_test_title "Basic icon message functions"

	assert_match_snapshot "$({

print_success "Operation completed successfully"
print_error "Failed to connect to database"
print_warning "Configuration file is missing"
print_info "Application started on port 8080"

	} | tee >(cat >&2))"
}

function test_custom_icons() {
	set_test_title "Custom icons"

	assert_match_snapshot "$({

print_success "Build passed" "🎉"
print_error "Build failed" "💥"
print_warning "Deprecated API" "⚠️"
print_info "New feature available" "💡"

	} | tee >(cat >&2))"
}

function test_long_messages() {
	set_test_title "Long messages"

	assert_match_snapshot "$({

print_success "This is a very long success message that demonstrates how the function handles extended text content with multiple words and detailed information about the successful operation"
print_error "This is a very long error message that demonstrates how the function handles extended text content with multiple words and detailed information about what went wrong"
print_warning "This is a very long warning message that demonstrates how the function handles extended text content with multiple words and detailed information about potential issues"
print_info "This is a very long informational message that demonstrates how the function handles extended text content with multiple words and detailed information for the user"

	} | tee >(cat >&2))"
}

function test_empty_messages() {
	set_test_title "Empty messages"

	assert_match_snapshot "$({

print_success ""
print_error ""
print_warning ""
print_info ""

	} | tee >(cat >&2))"
}

function test_messages_with_special_characters() {
	set_test_title "Messages with special characters"

	assert_match_snapshot "$({

print_success "Test: 100% complete! All checks passed ✓"
print_error "Error: File not found @ /var/log/app.log"
print_warning "Warning: Memory usage > 90% (critical threshold)"
print_info "Info: User #456 logged in from 192.168.1.1"

	} | tee >(cat >&2))"
}

function test_unicode_and_emoji_in_messages() {
	set_test_title "Unicode and emoji in messages"

	assert_match_snapshot "$({

print_success "Deployment successful 🚀"
print_error "Connection timeout ⏱️"
print_warning "SSL certificate expires soon 🔒"
print_info "Running in debug mode 🐛"

	} | tee >(cat >&2))"
}

function test_consecutive_messages() {
	set_test_title "Consecutive messages (no spacing)"

	assert_match_snapshot "$({

print_success "Step 1: Initialize"
print_success "Step 2: Configure"
print_success "Step 3: Deploy"
print_error "Step 4: Verify failed"
print_warning "Step 5: Rollback initiated"
print_info "Step 6: Cleanup pending"

	} | tee >(cat >&2))"
}

function test_all_four_functions_in_sequence() {
	set_test_title "All four functions in sequence"

	assert_match_snapshot "$({

print_success "Database migration completed"
print_error "Redis connection failed"
print_warning "API rate limit approaching"
print_info "Cache cleared successfully"

	} | tee >(cat >&2))"
}

function test_mixed_custom_icons() {
	set_test_title "Mixed custom icons"

	assert_match_snapshot "$({

print_success "Tests passed" "✅"
print_error "Tests failed" "❌"
print_warning "Tests skipped" "⏭️"
print_info "Tests running" "▶️"

	} | tee >(cat >&2))"
}

function test_empty_custom_icons() {
	set_test_title "Empty custom icons"

	assert_match_snapshot "$({

print_success "No icon message" ""
print_error "No icon error" ""
print_warning "No icon warning" ""
print_info "No icon info" ""

	} | tee >(cat >&2))"
}

function test_using_icon_flag() {
	set_test_title "Using --icon flag"

	assert_match_snapshot "$({

print_success "Build completed" --icon "🎉"
print_error "Build failed" --icon "💥"
print_warning "Deprecated" -i "⚠️"
print_info "New feature" -i "💡"

	} | tee >(cat >&2))"
}

function test_mixing_flags_and_positional_args() {
	set_test_title "Mixing flags and positional args"

	assert_match_snapshot "$({

print_success "Positional icon" "✅"
print_success "Flag icon" --icon "✅"

	} | tee >(cat >&2))"
}

function test_combining_n_with_icon() {
	set_test_title "Combining -n with --icon"

	assert_match_snapshot "$({

print_success -n "No newline" --icon "🚀"
echo " <- same line"
print_error -n "Critical error" --icon "🔥"
echo " <- same line"
print_warning -n "Warning message" -i "⚡"
echo " <- same line"

	} | tee >(cat >&2))"
}

function test_flag_takes_precedence_over_positional() {
	set_test_title "Flag takes precedence over positional"

	assert_match_snapshot "$({

print_success "Message" "❌" --icon "✅"
print_error "Message" "❌" -i "✅"

	} | tee >(cat >&2))"
}

run_tests -h "$(print_header -b $'\033[0;31m\033[1m' -t $'\033[0;33m\033[1m' "{name}")\n"

