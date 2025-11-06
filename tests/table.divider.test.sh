#!/usr/bin/env bash

. "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/../src/table.sh"
. "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/../src/header.sh"
. "${BPKG_DEPS:-$(cd "$(dirname "${BASH_SOURCE[0]}")/../deps" && pwd)}/tui-testkit/src/bashunit-compatible.sh"

function test_basic_table_with_dividers_between_rows() {
	set_test_title "Basic table with dividers between rows"

	assert_match_snapshot "$({

print_table_start
print_table_headers "Name" "Age" "City"
print_table_row "Alice" "25" "NYC"
print_table_row "Bob" "30" "LA"
print_table_divider
print_table_row "Charlie" "35" "SF"
print_table_row "Diana" "28" "Boston"
print_table_divider
print_table_row "Eve" "32" "Seattle"
print_table_end

	} | tee >(cat >&2))"
}

function test_dividers_with_different_column_widths_and_colored_borders() {
	set_test_title "Dividers with different column widths and colored borders"

	assert_match_snapshot "$({

print_table_start  --border $'\033[0;35m' --cell $'\033[0;32m'
print_table_headers ":Short" ":Medium Column:" "Long Column Name:"
print_table_row "A" "B" "C"
print_table_divider
print_table_row "AAA" "BBB" "CCC"
print_table_divider
print_table_row "AAAAA" "BBBBB" "CCCCC"
print_table_end

	} | tee >(cat >&2))"
}

run_tests -h "$(print_header -b $'\033[0;31m\033[1m' -t $'\033[0;33m\033[1m' "{name}")\n"

