#!/usr/bin/env bash

. "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/../src/table.sh"
. "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/../src/header.sh"
. "${BPKG_DEPS:-$(cd "$(dirname "${BASH_SOURCE[0]}")/../deps" && pwd)}/tui-testkit/src/bashunit-compatible.sh"

function test_basic_multiple_headers() {
	set_test_title "Basic multiple headers"

	assert_match_snapshot "$({

print_table_start
print_table_headers "Name" "Age" "City"
print_table_row "Alice" "25" "NYC"
print_table_row "Bob" "30" "LA"
print_table_headers "Product" "Price" "Stock"
print_table_row "Widget" "\$10" "100"
print_table_row "Gadget" "\$20" "50"
print_table_end

	} | tee >(cat >&2))"
}

function test_multiple_headers_with_switching_alignment() {
	set_test_title "Multiple headers with switching alignment"

	assert_match_snapshot "$({

print_table_start --margin 2 --center
print_table_headers ": Left " ":Center:" "Right :"
print_table_row "A" "B" "C"
print_table_row "AAA" "BBB" "CCC"
print_table_headers "Right:" ":Left" ":Center:"
print_table_row "X" "Y" "Z"
print_table_row "XXX" "YYY" "ZZZ"
print_table_headers ":Center:" "Right:" ":Left"
print_table_row "1" "2" "3"
print_table_row "111" "222" "333"
print_table_end

	} | tee >(cat >&2))"
}

function test_multiple_headers_with_dividers_and_dynamic_redraw() {
	set_test_title "Multiple headers with dividers and dynamic redraw"

	assert_match_snapshot "$({

print_table_start --center
print_table_headers ":Name" ":Age:" "City:"
print_table_row "Alice" "25" "NYC"
print_table_row "Bob" "30" "LA"
print_table_divider
print_table_row "Charlie" "35" "SF"
print_table_headers "Product:" ":Price:" ":Stock"
print_table_row "Widget" "10" "100"
print_table_row "Gadget" "20" "50"
print_table_divider
print_table_row "Gizmo" "30" "25"
print_table_headers ":VeryLongHeaderName" ":Amount:" "Status:"
print_table_row "Item1" "999" "Active"
print_table_row "Item2" "888" "Pending"
print_table_end

	} | tee >(cat >&2))"
}

run_tests -h "$(print_header -b $'\033[0;31m\033[1m' -t $'\033[0;33m\033[1m' "{name}")\n"

