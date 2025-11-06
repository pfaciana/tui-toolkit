#!/usr/bin/env bash

. "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/../src/table.sh"
. "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/../src/header.sh"
. "${BPKG_DEPS:-$(cd "$(dirname "${BASH_SOURCE[0]}")/../deps" && pwd)}/tui-testkit/src/bashunit-compatible.sh"

function test_all_left_aligned() {
	set_test_title "All Left Aligned"

	assert_match_snapshot "$({

print_table_start
print_table_headers "C1" "C2" "C3"
print_table_row "Short" "Medium" "Long Text Here"
print_table_row "X" "Y" "Z"
print_table_end

	} | tee >(cat >&2))"
}

function test_all_right_aligned() {
	set_test_title "All Right Aligned"

	assert_match_snapshot "$({

print_table_start
print_table_headers "C1:" "C2:" "C3:"
print_table_row "1" "22" "333"
print_table_row "4444" "55555" "666666"
print_table_end

	} | tee >(cat >&2))"
}

function test__all_center_aligned() {
	set_test_title "All Center Aligned"

	assert_match_snapshot "$({

print_table_start --center
print_table_headers ":C1:" ":C2:" ":C3:"
print_table_row "A" "BB" "CCC"
print_table_row "DDDD" "EEEEE" "FFFFFF"
print_table_end

	} | tee >(cat >&2))"
}

run_tests -h "$(print_header -b $'\033[0;31m\033[1m' -t $'\033[0;33m\033[1m' "{name}")\n"
