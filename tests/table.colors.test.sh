#!/usr/bin/env bash

. "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/../src/table.sh"
. "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/../src/header.sh"
. "${BPKG_DEPS:-$(cd "$(dirname "${BASH_SOURCE[0]}")/../deps" && pwd)}/tui-testkit/src/bashunit-compatible.sh"

function test_ansi_colors_colored_borders_cells() {
	set_test_title "ANSI colors colored borders/cells (default margin/padding)"

	assert_match_snapshot "$({

print_table_start --center --border $'\033[0;33m\033[45m' --cell $'\033[0;30m\033[43m'
print_table_headers ":C1" $':\033[0;36mC2:' "C3:"
print_table_row "A" "B" "C"
print_table_row "AAA" "BBB" "CCC"
print_table_row "AA" $'\033[0;37m\033[41m\033[1mBBBBB' "CC"
print_table_row "A" "B" "CCCCCCCCCC"
print_table_end

	} | tee >(cat >&2))"
}

function test_ansi_colors_with_padding_1() {
	set_test_title "ANSI colors with padding=1"

	assert_match_snapshot "$({

print_table_start --padding 1 --center --border $'\033[0;33m\033[45m' --cell $'\033[0;30m\033[43m'
print_table_headers ":C1" $':\033[0;36mC2:' "C3:"
print_table_row "A" "B" "C"
print_table_row "AAA" "BBB" "CCC"
print_table_row "AA" $'\033[0;37m\033[41m\033[1mBBBBB' "CC"
print_table_row "A" "B" "CCCCCCCCCC"
print_table_end

	} | tee >(cat >&2))"
}

function test_ansi_colors_with_margin_3_padding_0() {
	set_test_title "ANSI colors with margin=3, padding=0"

	assert_match_snapshot "$({

print_table_start --margin 3 --center --border $'\033[0;33m\033[45m' --cell $'\033[0;30m\033[43m'
print_table_headers ":C1" $':\033[0;36mC2:' "C3:"
print_table_row "A" "B" "C"
print_table_row "AAA" "BBB" "CCC"
print_table_row "AA" $'\033[0;37m\033[41m\033[1mBBBBB' "CC"
print_table_row "A" "B" "CCCCCCCCCC"
print_table_end

	} | tee >(cat >&2))"
}

function test_ansi_colors_with_margin_0_padding_3_multiple_headers() {
	set_test_title "ANSI colors with margin=0, padding=3, and multiple headers"

	assert_match_snapshot "$({

print_table_start --margin 0 --padding 3 --center --border $'\033[0;33m\033[45m' --cell $'\033[0;30m\033[43m'
print_table_headers ":C1" $':\033[0;36mC2:' "C3:"
print_table_row "A" "B" "C"
print_table_row "AAA" "BBB" "CCC"
print_table_headers "C1:" $':\033[0;36mC2:' ":C3"
print_table_row "AA" $'\033[0;37m\033[41m\033[1mBBBBB' "CC"
print_table_row "A" "B" "CCCCCCCCCC"
print_table_end

	} | tee >(cat >&2))"
}

run_tests -h "$(print_header -b $'\033[0;31m\033[1m' -t $'\033[0;33m\033[1m' "{name}")\n"

