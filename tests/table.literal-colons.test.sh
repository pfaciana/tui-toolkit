#!/usr/bin/env bash

. "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/../src/table.sh"
. "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/../src/header.sh"
. "${BPKG_DEPS:-$(cd "$(dirname "${BASH_SOURCE[0]}")/../deps" && pwd)}/tui-testkit/src/bashunit-compatible.sh"

function test_rows_with_literal_colons_dont_override_header_alignment() {
	set_test_title "Rows with literal colons don't override header alignment"

	assert_match_snapshot "$({

print_table_start
print_table_headers ":Left" ":Center:" "Right:"
print_table_row "A:" ":B" ":C:"
print_table_row "A" "B" "C"
print_table_end

	} | tee >(cat >&2))"
}

function test_no_headers_colons_in_row_data_are_literal() {
	set_test_title "No headers, colons in row data are literal (not alignment markers)"

	assert_match_snapshot "$({

print_table_start
print_table_row ":Left" ":Center:" "Right:"
print_table_row "A:B" "C:D:E" "F:"
print_table_row "AAAAAAAAA" "BBBBBBBBB" "CCCCCCCCC"
print_table_row ":::" ":" "::"
print_table_end

	} | tee >(cat >&2))"
}

run_tests -h "$(print_header -b $'\033[0;31m\033[1m' -t $'\033[0;33m\033[1m' "{name}")\n"

