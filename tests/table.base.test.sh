#!/usr/bin/env bash

. "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/../src/table.sh"
. "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/../src/header.sh"
. "${BPKG_DEPS:-$(cd "$(dirname "${BASH_SOURCE[0]}")/../deps" && pwd)}/tui-testkit/src/bashunit-compatible.sh"

function test_basic_table_with_auto_sizing_columns() {
	set_test_title "Basic table with auto-sizing columns"

	assert_match_snapshot "$({

print_table_start
print_table_headers "C1" "C2" "C3"
sleep 1
print_table_row "A" "B" "C"
sleep 1
print_table_row "Aaaaaaaaa" "Bbbbbbbbb" "Ccccccccc"
sleep 1
print_table_row "A" "B" "C"
print_table_end

	} | tee >(cat >&2))"
}

function test_centered_headers() {
	set_test_title "Centered headers"

	assert_match_snapshot "$({

print_table_start --center
print_table_headers "C1" "C2" "C3"
print_table_row "Aaaaaaaaa" "Bbbbbbbbb" "Ccccccccc"
print_table_end

	} | tee >(cat >&2))"
}

function test_table_without_headers() {
	set_test_title "Table without headers"

	assert_match_snapshot "$({

print_table_start
print_table_row "A" "B"
print_table_row "AAA" "BBB"
print_table_row "AA" "BBBBB"
print_table_row "A" "BB"
print_table_end

	} | tee >(cat >&2))"
}

function test_single_column_with_ansi_colors() {
	set_test_title "Single Column with ANSI colors"

	assert_match_snapshot "$({

print_table_start --border $'\033[0;36m'
print_table_headers "Status"
print_table_row $'Server: \033[0;32mOnline\033[0m'
print_table_row $'Database: \033[0;31mOffline\033[0m'
print_table_end

	} | tee >(cat >&2))"
}

function test_many_columns() {
	set_test_title "Many columns"

	assert_match_snapshot "$({

print_table_start
print_table_headers "A" "B" "C" "D" "E" "F" "G"
print_table_row "1" "2" "3" "4" "5" "6" "7"
print_table_row "11" "22" "33" "44" "55" "66" 77
print_table_end

	} | tee >(cat >&2))"
}

function test_ansi_control_sequences() {
	set_test_title "ANSI control sequences"

	assert_match_snapshot "$({

print_table_start --center --border $'\033[0;32m' --cell $'\033[0m'
print_table_headers ":Left" ":Center:" "Right:"
print_table_row "A" "B" "C"
print_table_row $'\033[1mBold' $'\033[3mItalic' $'\033[4mUnderline'
print_table_row "Short" "Medium Text" "X"
print_table_end

	} | tee >(cat >&2))"
}

run_tests -h "$(print_header -b $'\033[0;31m\033[1m' -t $'\033[0;33m\033[1m' "{name}")\n"

