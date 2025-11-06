#!/usr/bin/env bash

. "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/../src/table.sh"
. "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/../src/header.sh"
. "${BPKG_DEPS:-$(cd "$(dirname "${BASH_SOURCE[0]}")/../deps" && pwd)}/tui-testkit/src/bashunit-compatible.sh"

function test_dynamic_redraw_with_temporary_messages() {
	set_test_title "Dynamic redraw with temporary messages"

	assert_match_snapshot "$({

print_table_start
print_table_headers "Col1" "Col2" "Col3"
print_table_row "A" "B" "C"
sleep 1
print_table_message "Doing step 1..."
sleep 1
print_table_message "Doing step 2..."
sleep 1
print_table_row "AAAA" "BBBB" "CCCC"
print_table_message "Doing step 3..."
sleep 1
print_table_row "AAAAAAA" "BBBBBBB" "CCCCCCC"
print_table_message "Adding row 4 (no redraw needed)..."
sleep 1
print_table_row "AA" "BB" "CC"
print_table_end

	} | tee >(cat >&2))"
}

run_tests -h "$(print_header -b $'\033[0;31m\033[1m' -t $'\033[0;33m\033[1m' "{name}")\n"

