#!/usr/bin/env bash

. "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/../src/table.sh"
. "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/../src/header.sh"
. "${BPKG_DEPS:-$(cd "$(dirname "${BASH_SOURCE[0]}")/../deps" && pwd)}/tui-testkit/src/bashunit-compatible.sh"

function test_max_width_truncation_with_default_ellipsis() {
	set_test_title "Max width truncation with default ellipsis"

	assert_match_snapshot "$({

print_table_start --max-width 10 --center
print_table_headers "Short" "Long Column"
print_table_row "OK" "This is a very long text that should be truncated"
print_table_row "Yes" "Another long one here"
print_table_row "-------" "?"
print_table_end

	} | tee >(cat >&2))"
}

function test_max_width_truncation_with_custom_ellipsis() {
	set_test_title "Max width truncation with custom ellipsis"

	assert_match_snapshot "$({

print_table_start --max-width 10 --ellipsis "....."
print_table_headers "Short" "Long Column"
print_table_row "OK" "This is a very long text that should be truncated"
print_table_row "Yes" "Another long one here"
print_table_row " " "?"
print_table_end

	} | tee >(cat >&2))"
}

run_tests -h "$(print_header -b $'\033[0;31m\033[1m' -t $'\033[0;33m\033[1m' "{name}")\n"

