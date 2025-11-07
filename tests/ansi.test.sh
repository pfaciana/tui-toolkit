#!/usr/bin/env bash

. "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/../src/ansi.sh"
. "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/../src/header.sh"
. "${BPKG_DEPS:-$(cd "$(dirname "${BASH_SOURCE[0]}")/../deps" && pwd)}/tui-testkit/src/bashunit-compatible.sh"

# --- tiny helpers for visuals ---
bg() { printf "\033[%sm%s\033[0m\n" "$1" "$2"; }  # usage: bg 41 "text"

function test_delete_line() {
	set_test_title "Delete line"

	assert_match_snapshot "$({

bg 41 "L1 (red bg)"
bg 42 "L2 (green bg)"
bg 44 "L3 (blue bg)"
bg 45 "L4 (magenta bg) <-- Should end after here"
bg 46 "L5 (cyan bg)"
sleep 1
delete_line

	} | tee >(cat >&2))"
}

function test_delete_3_lines() {
 	set_test_title "Delete three lines"

 	assert_match_snapshot "$({

bg 41 "L1 (red bg)"
bg 42 "L2 (green bg) <-- Should end after here"
bg 44 "L3 (blue bg)"
bg 45 "L4 (magenta bg)"
bg 46 "L5 (cyan bg)"
sleep 1
delete_lines 3

 	} | tee >(cat >&2))"
}

function test_delete_next_line() {
 	set_test_title "Delete next line"

 	assert_match_snapshot "$({

bg 41 "L1 (red bg)"
bg 42 "L2 (green bg)"
bg 44 "L3 (blue bg) <-- Line after this should be deleted"
bg 45 "L4 (magenta bg)"
bg 46 "L5 (cyan bg)"
sleep 2
printf '\e[3F'
delete_lines -1
printf '\e[1E' # reset cursor position for the next test

 	} | tee >(cat >&2))"
}

function test_delete_next_2_lines() {
 	set_test_title "Delete next 2 lines"

 	assert_match_snapshot "$({

bg 41 "L1 (red bg) <-- 2 lines after this should be deleted"
bg 42 "L2 (green bg)"
bg 44 "L3 (blue bg)"
bg 45 "L4 (magenta bg)"
bg 46 "L5 (cyan bg)"
sleep 2
printf '\e[5F'
delete_lines -2
printf '\e[2E' # reset cursor position for the next test

 	} | tee >(cat >&2))"
}

function test_current_line() {
 	set_test_title "Delete current line"

 	assert_match_snapshot "$({

bg 41 "L1 (red bg)"
bg 42 "L2 (green bg)"
bg 44 "L3 (blue bg)"
bg 45 "L4 (magenta bg) <-- Line after this should be cleared"
bg 46 "L5 (cyan bg) <-- Cursor is moved back to this line"
sleep 2
printf '\e[F'
clear_current_line

 	} | tee >(cat >&2))"
}

function test_current_line_after_move_to_middle() {
 	set_test_title "Delete current line after moving to middle of the section"

 	assert_match_snapshot "$({

bg 41 "L1 (red bg)"
bg 42 "L2 (green bg) <-- Line after this should be cleared"
bg 44 "L3 (blue bg) <-- Cursor is moved back to this line"
bg 45 "L4 (magenta bg)"
bg 46 "L5 (cyan bg)"
sleep 2
printf '\e[3F'
clear_current_line
printf '\e[3E' # reset cursor position for the next test

 	} | tee >(cat >&2))"
}

run_tests -h "$(print_header -b $'\033[0;31m\033[1m' -t $'\033[0;33m\033[1m' "{name}")\n"