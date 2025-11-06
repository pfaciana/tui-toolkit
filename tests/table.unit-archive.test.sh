. "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/../src/table.sh"

test_count=0
pass_count=0

assert_equals() {
    local expected="$1"
    local actual="$2"
    local test_name="$3"

    ((test_count++))
    if [[ "$expected" == "$actual" ]]; then
        ((pass_count++))
        echo "✓ $test_name"
    else
        echo "✗ $test_name"
        echo "  Expected: '$expected'"
        echo "  Actual:   '$actual'"
    fi
}

echo "--- Testing strip_ansi ---"
result=$(strip_ansi "Hello World")
assert_equals "Hello World" "$result" "Plain text"

result=$(strip_ansi $'\033[0;31mRed\033[0m')
assert_equals "Red" "$result" "Red text"

result=$(strip_ansi $'\033[0;36m\033[1mBold Cyan\033[0m')
assert_equals "Bold Cyan" "$result" "Bold cyan text"

echo

echo "--- Testing visible_length ---"
result=$(visible_length "Hello")
assert_equals "5" "$result" "Plain text length"

result=$(visible_length $'\033[0;31mRed\033[0m')
assert_equals "3" "$result" "Colored text length"

echo

echo "--- Testing parse_alignment ---"
result=$(parse_alignment "Text")
assert_equals "left|Text" "$result" "Left align (default)"

result=$(parse_alignment ":Text")
assert_equals "left|Text" "$result" "Left align (explicit)"

result=$(parse_alignment "Text:")
assert_equals "right|Text" "$result" "Right align"

result=$(parse_alignment ":Text:")
assert_equals "center|Text" "$result" "Center align"

echo

echo "--- Testing strip_ansi ---"
result=$(strip_ansi "Hello World")
assert_equals "Hello World" "$result" "Plain text"

result=$(strip_ansi $'\033[0;31mRed\033[0m')
assert_equals "Red" "$result" "Red text"

result=$(strip_ansi $'\033[0;36m\033[1mBold Cyan\033[0m')
assert_equals "Bold Cyan" "$result" "Bold cyan text"

echo

echo "--- Testing visible_length ---"
result=$(visible_length "Hello")
assert_equals "5" "$result" "Plain text length"

result=$(visible_length $'\033[0;31mRed\033[0m')
assert_equals "3" "$result" "Colored text length"

echo

echo "--- Testing parse_alignment ---"
result=$(parse_alignment "Text")
assert_equals "left|Text" "$result" "Left align (default)"

result=$(parse_alignment ":Text")
assert_equals "left|Text" "$result" "Left align (explicit)"

result=$(parse_alignment "Text:")
assert_equals "right|Text" "$result" "Right align"

result=$(parse_alignment ":Text:")
assert_equals "center|Text" "$result" "Center align"

echo

echo "Tests passed: $pass_count/$test_count"
echo
