#!/usr/bin/env bash

. "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/../src/messages.sh"
. "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/../src/header.sh"
. "${BPKG_DEPS:-$(cd "$(dirname "${BASH_SOURCE[0]}")/../deps" && pwd)}/tui-testkit/src/bashunit-compatible.sh"

function test_basic_process_message_functions() {
	set_test_title "Basic process message functions"

	assert_match_snapshot "$({

print_step "Starting application initialization"
print_progress "Loading configuration files"
print_finish "Application ready to serve requests"
print_log "Server listening on port 3000"

	} | tee >(cat >&2))"
}

function test_custom_icons() {
	set_test_title "Custom icons"

	assert_match_snapshot "$({

print_step "Begin deployment" "🚀"
print_progress "Uploading files" "📤"
print_finish "Deployment complete" "🎊"
print_log "Logged event" "📝"

	} | tee >(cat >&2))"
}

function test_long_messages() {
	set_test_title "Long messages"

	assert_match_snapshot "$({

print_step "This is a very long step message that demonstrates how the function handles extended text content with multiple words and detailed information about the current step in the process"
print_progress "This is a very long progress message that demonstrates how the function handles extended text content with multiple words and detailed information about ongoing operations"
print_finish "This is a very long finish message that demonstrates how the function handles extended text content with multiple words and detailed information about the completed process"
print_log "This is a very long log message that demonstrates how the function handles extended text content with multiple words and detailed information for logging purposes"

	} | tee >(cat >&2))"
}

function test_empty_messages() {
	set_test_title "Empty messages"

	assert_match_snapshot "$({

print_step ""
print_progress ""
print_finish ""
print_log ""

	} | tee >(cat >&2))"
}

function test_messages_with_special_characters() {
	set_test_title "Messages with special characters"

	assert_match_snapshot "$({

print_step "Step: Initialize database @ /var/lib/db"
print_progress "Progress: 75% complete (3/4 tasks)"
print_finish "Finish: All 100% tasks completed ✓"
print_log "Log: User #789 performed action"

	} | tee >(cat >&2))"
}

function test_workflow_simulation() {
	set_test_title "Workflow simulation"

	assert_match_snapshot "$({

print_step "Step 1: Validate input"
print_progress "Processing data..."
print_step "Step 2: Transform data"
print_progress "Applying transformations..."
print_step "Step 3: Save results"
print_progress "Writing to database..."
print_finish "Workflow completed successfully"

	} | tee >(cat >&2))"
}

function test_consecutive_messages() {
	set_test_title "Consecutive messages (no spacing)"

	assert_match_snapshot "$({

print_step "Initialize"
print_step "Configure"
print_step "Execute"
print_progress "Running..."
print_progress "Almost done..."
print_finish "Complete"
print_log "Process finished"

	} | tee >(cat >&2))"
}

function test_all_four_functions_in_sequence() {
	set_test_title "All four functions in sequence"

	assert_match_snapshot "$({

print_step "Starting backup process"
print_progress "Backing up database (this may take a while)"
print_finish "Backup completed successfully"
print_log "Backup saved to /backups/db-2024-10-31.sql"

	} | tee >(cat >&2))"
}

function test_mixed_custom_icons() {
	set_test_title "Mixed custom icons"

	assert_match_snapshot "$({

print_step "Build step" "🔨"
print_progress "Building..." "⚙️"
print_finish "Build done" "✨"
print_log "Build log" "📋"

	} | tee >(cat >&2))"
}

function test_empty_custom_icons() {
	set_test_title "Empty custom icons"

	assert_match_snapshot "$({

print_step "No icon step" ""
print_progress "No icon progress" ""
print_finish "No icon finish" ""
print_log "No icon log" ""

	} | tee >(cat >&2))"
}

function test_multi_step_process() {
	set_test_title "Multi-step process"

	assert_match_snapshot "$({

print_step "Phase 1: Preparation"
print_progress "Downloading dependencies"
print_progress "Installing packages"
print_step "Phase 2: Compilation"
print_progress "Compiling source code"
print_progress "Running tests"
print_step "Phase 3: Deployment"
print_progress "Uploading artifacts"
print_finish "All phases completed"
print_log "Total time: 2m 34s"

	} | tee >(cat >&2))"
}

function test_using_icon_flag() {
	set_test_title "Using --icon flag"

	assert_match_snapshot "$({

print_step "Starting process" --icon "🔵"
print_progress "Processing..." -i "⏳"
print_finish "All done!" --icon "🎊"
print_log "Log entry" -i "📝"

	} | tee >(cat >&2))"
}

function test_combining_n_with_icon() {
	set_test_title "Combining -n with --icon"

	assert_match_snapshot "$({

print_step -n "Loading" --icon "⏳"
echo " <- same line"
print_progress -n "Processing" -i "⚙️"
echo " <- same line"

	} | tee >(cat >&2))"
}

function test_flag_takes_precedence_over_positional() {
	set_test_title "Flag takes precedence over positional"

	assert_match_snapshot "$({

print_step "Message" "❌" --icon "✅"
print_finish "Message" "❌" -i "🎉"

	} | tee >(cat >&2))"
}

run_tests -h "$(print_header -b $'\033[0;31m\033[1m' -t $'\033[0;33m\033[1m' "{name}")\n"

