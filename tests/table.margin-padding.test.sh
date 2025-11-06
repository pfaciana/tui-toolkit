#!/usr/bin/env bash

. "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/../src/table.sh"
. "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/../src/header.sh"
. "${BPKG_DEPS:-$(cd "$(dirname "${BASH_SOURCE[0]}")/../deps" && pwd)}/tui-testkit/src/bashunit-compatible.sh"

function test_default_margin_1_padding_0() {
	set_test_title "Default (margin=1, padding=0)"

	assert_match_snapshot "$({

print_table_start
print_table_headers "Name" "Age" "Location"
print_table_row "Alice" "25" "NYC"
print_table_row "Bob" "30" "LA"
print_table_end

	} | tee >(cat >&2))"
}

function test_left_right_center_with_padding() {
	set_test_title "Left/Right/Center with padding (margin=1, padding=1)"

	assert_match_snapshot "$({

print_table_start --padding 1
print_table_headers ":Name" "Age:" ":Location:"
print_table_row "Alice" "25" "NYC"
print_table_row "Bob" "30" "LA"
print_table_end

	} | tee >(cat >&2))"
}

function test_no_margin() {
	set_test_title "No margin (margin=0, padding=0)"

	assert_match_snapshot "$({

print_table_start --margin 0
print_table_headers "Name" "Age" "Location"
print_table_row "Alice" "25" "NYC"
print_table_row "Bob" "30" "LA"
print_table_end

	} | tee >(cat >&2))"
}

function test_margin_vs_padding_styling_with_colored_borders_and_cells() {
	set_test_title "Margin vs padding styling with colored borders and cells"

	assert_match_snapshot "$({

print_table_start --margin 2 --padding 1 --border $'\033[48;5;240m' --cell $'\033[48;5;22m'
print_table_headers "Name" "Age" "Location"
print_table_row "Alice" "25" "NYC"
print_table_row "Bob" "30" "LA"
print_table_end

	} | tee >(cat >&2))"
}

run_tests -h "$(print_header -b $'\033[0;31m\033[1m' -t $'\033[0;33m\033[1m' "{name}")\n"

