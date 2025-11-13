#!/usr/bin/env bash

. "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/../src/header.sh"
. "${BPKG_DEPS:-$(cd "$(dirname "${BASH_SOURCE[0]}")/../deps" && pwd)}/tui-testkit/src/bashunit-compatible.sh"

function test_basic_header() {
	set_test_title "Basic header (left-aligned, default width 80, padding 1)"

	assert_match_snapshot "$({

print_header "Welcome to My Application"

	} | tee >(cat >&2))"
}

function test_center_aligned_header() {
	set_test_title "Center-aligned header"

	assert_match_snapshot "$({

print_header -c "Welcome to My Application"

	} | tee >(cat >&2))"
}

function test_closed_box() {
	set_test_title "Closed box (with trailing border)"

	assert_match_snapshot "$({

print_header -d "Welcome to My Application"

	} | tee >(cat >&2))"
}

function test_center_aligned_and_closed() {
	set_test_title "Center-aligned and closed"

	assert_match_snapshot "$({

print_header -c -d "Welcome to My Application"

	} | tee >(cat >&2))"
}

function test_custom_width() {
	set_test_title "Custom width"

	assert_match_snapshot "$({

print_header -w 60 "Short Title"

	} | tee >(cat >&2))"
}

function test_fit_width_to_content() {
	set_test_title "Fit width to content"

	assert_match_snapshot "$({

print_header --fit "Exact Fit"

	} | tee >(cat >&2))"
}

function test_fit_width_with_center_alignment() {
	set_test_title "Fit width with center alignment"

	assert_match_snapshot "$({

print_header -f -c "Centered and Fitted"

	} | tee >(cat >&2))"
}

function test_padding_0() {
	set_test_title "Padding 0 (no padding)"

	assert_match_snapshot "$({

print_header -p 0 "No Padding"

	} | tee >(cat >&2))"
}

function test_padding_2() {
	set_test_title "Padding 2 (2 spaces left/right, 1 row top/bottom)"

	assert_match_snapshot "$({

print_header -p 2 "More Padding"

	} | tee >(cat >&2))"
}

function test_padding_3() {
	set_test_title "Padding 3 (3 spaces left/right, 2 rows top/bottom)"

	assert_match_snapshot "$({

print_header --padding 3 --center "Even More Padding"

	} | tee >(cat >&2))"
}

function test_text_too_long_for_box() {
	set_test_title "Text too long for box (no trailing border even with -d)"

	assert_match_snapshot "$({

print_header -d -w 30 "This is a very long title that exceeds the box width"

	} | tee >(cat >&2))"
}

function test_custom_border_color() {
	set_test_title "Custom border color (yellow)"

	assert_match_snapshot "$({

print_header -b $'\033[0;33m\033[1m' "Custom Border Color"

	} | tee >(cat >&2))"
}

function test_custom_cell_color() {
	set_test_title "Custom cell color (green)"

	assert_match_snapshot "$({

print_header -t $'\033[0;32m\033[1m' "Custom Text Color"

	} | tee >(cat >&2))"
}

function test_custom_border_and_cell_colors() {
	set_test_title "Custom border and cell colors"

	assert_match_snapshot "$({

print_header --border $'\033[0;35m\033[1m' --cell $'\033[0;36m\033[1m' "Purple Border, Cyan Text"

	} | tee >(cat >&2))"
}

function test_all_options_combined() {
	set_test_title "All options combined"

	assert_match_snapshot "$({

print_header "Full Featured Header" -c -d -p 2 -w 70 -b $'\033[0;33m\033[1m' -t $'\033[0;32m\033[1m'

	} | tee >(cat >&2))"
}

function test_multiple_headers_in_sequence() {
	set_test_title "Multiple headers in sequence"

	assert_match_snapshot "$({

print_header -c "Section 1: Configuration"
print_header -c "Section 2: Processing"
print_header -c "Section 3: Results"

	} | tee >(cat >&2))"
}

function test_fit_with_closed_box() {
	set_test_title "Fit with closed box"

	assert_match_snapshot "$({

print_header "Perfect Fit" -f -d

	} | tee >(cat >&2))"
}

run_tests -h "\n\n➤➤➤  {name}"

