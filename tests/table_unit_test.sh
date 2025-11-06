#!/usr/bin/env bash

# Source the table module to test
. "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/../src/table.sh"

# Tests for strip_ansi function
function test_strip_ansi_plain_text() {
    local result
    result=$(strip_ansi "Hello World")
    assert_same "Hello World" "$result"
}

function test_strip_ansi_red_text() {
    local result
    result=$(strip_ansi $'\033[0;31mRed\033[0m')
    assert_same "Red" "$result"
}

function test_strip_ansi_bold_cyan_text() {
    local result
    result=$(strip_ansi $'\033[0;36m\033[1mBold Cyan\033[0m')
    assert_same "Bold Cyan" "$result"
}

# Tests for visible_length function
function test_visible_length_plain_text() {
    local result
    result=$(visible_length "Hello")
    assert_same "5" "$result"
}

function test_visible_length_colored_text() {
    local result
    result=$(visible_length $'\033[0;31mRed\033[0m')
    assert_same "3" "$result"
}

# Tests for parse_alignment function
function test_parse_alignment_default_left() {
    local result
    result=$(parse_alignment "Text")
    assert_same "left|Text" "$result"
}

function test_parse_alignment_explicit_left() {
    local result
    result=$(parse_alignment ":Text")
    assert_same "left|Text" "$result"
}

function test_parse_alignment_right() {
    local result
    result=$(parse_alignment "Text:")
    assert_same "right|Text" "$result"
}

function test_parse_alignment_center() {
    local result
    result=$(parse_alignment ":Text:")
    assert_same "center|Text" "$result"
}

