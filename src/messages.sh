#!/bin/bash

if [[ -n "${_MESSAGES_LOADED:-}" ]]; then
    return 0
fi
_MESSAGES_LOADED=1

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/ansi.sh"

# usage: echo "A$(spaces 5)B"
spaces() {
	printf '%*s' "$1" '';
}

# Parse common message arguments and return associative array
# Usage: _parse_args "$@"
# Returns associative array with keys: text, value, nl
_parse_args() {
    local -n result=$1
    shift

    result[nl]="\n"
    local pos=() icon="" status="" padding=2

    while (( $# )); do
        case "$1" in
            -n) result[nl]=""; shift ;;
            -i|--icon) icon="$2"; shift 2 ;;
            -s|--status) status="$2"; shift 2 ;;
            -p|--padding) padding="$2"; shift 2 ;;
            *)  pos+=("$1"); shift ;;
        esac
    done

    result[text]="${pos[0]}"
    result[icon]="${icon:-${pos[1]}}"
    result[status]="${status:-${pos[1]}}"
    result[padding]=$(spaces ${padding})
}

# ============================================================================
# OUTPUT BG COLOR MESSAGE
# ============================================================================

# Print PASS status 🟩🟩🟩🟩⚪⚪⚪⚪⚪
# Parameters: [-n] message [status] [-s|--status status]
# -n: Do not output a trailing newline
# -s|--status: Custom status text
print_pass() {
    local -A args
    _parse_args args "$@"
    printf "${WH}${BG_GN}${BOLD} %s ${NC}${args[text]:+${args[padding]}}${GN}${BOLD}%s${NC}${args[nl]}" "${args[status]:-PASS}" "${args[text]}"
}

# Print FAIL status 🟥🟥🟥🟥⚪⚪⚪⚪⚪
# Parameters: [-n] message [status] [-s|--status status]
# -n: Do not output a trailing newline
# -s|--status: Custom status text
print_fail() {
    local -A args
    _parse_args args "$@"
    printf "${WH}${BG_RD}${BOLD} %s ${NC}${args[text]:+${args[padding]}}${RD}${BOLD}%s${NC}${args[nl]}" "${args[status]:-FAIL}" "${args[text]}"
}

# Print WARN status 🟨🟨🟨🟨⚪⚪⚪⚪⚪
# Parameters: [-n] message [status] [-s|--status status]
# -n: Do not output a trailing newline
# -s|--status: Custom status text
print_warn() {
    local -A args
    _parse_args args "$@"
    printf "${WH}${BG_YL}${BOLD} %s ${NC}${args[text]:+${args[padding]}}${YL}${BOLD}%s${NC}${args[nl]}" "${args[status]:-WARN}" "${args[text]}"
}

# Print WARN status 🟦🟦🟦🟦⚪⚪⚪⚪
# Parameters: [-n] message [status] [-s|--status status]
# -n: Do not output a trailing newline
# -s|--status: Custom status text
print_inform() {
    local -A args
    _parse_args args "$@"
    printf "${WH}${BG_CY}${BOLD} %s ${NC}${args[text]:+${args[padding]}}${CY}${BOLD}%s${NC}${args[nl]}" "${args[status]:-INFO}" "${args[text]}"
}

# ============================================================================
# OUTPUT ICON MESSAGE
# ============================================================================

# Print success message 🟢 ✓ ⚪⚪⚪⚪⚪
# Parameters: [-n] message [icon] [-i|--icon icon]
# -n: Do not output a trailing newline
# -i|--icon: Custom icon
print_success() {
    local -A args
    _parse_args args "$@"
    printf "\0337${GN}${BOLD}%s\0338\033[3C${GN}${BOLD}%s${NC}${args[nl]}" "${args[icon]:-$ICON_SUCCESS}" "${args[text]}"
}

# Print error message 🔴 ✗ ⚪⚪⚪⚪⚪
# Parameters: [-n] message [icon] [-i|--icon icon]
# -n: Do not output a trailing newline
# -i|--icon: Custom icon
print_error() {
    local -A args
    _parse_args args "$@"
    printf "\0337${RD}${BOLD}%s\0338\033[3C${RD}${BOLD}%s${NC}${args[nl]}" "${args[icon]:-$ICON_ERROR}" "${args[text]}"
}

# Print warning message 🟡 ⚠ ⚪⚪⚪⚪⚪
# Parameters: [-n] message [icon] [-i|--icon icon]
# -n: Do not output a trailing newline
# -i|--icon: Custom icon
print_warning() {
    local -A args
    _parse_args args "$@"
    printf "\0337${YL}${BOLD}%s\0338\033[3C${YL}${BOLD}%s${NC}${args[nl]}" "${args[icon]:-$ICON_WARNING}" "${args[text]}"
}

# Print info message 🔵 ℹ ⚪⚪⚪⚪⚪
# Parameters: [-n] message [icon] [-i|--icon icon]
# -n: Do not output a trailing newline
# -i|--icon: Custom icon
print_info() {
    local -A args
    _parse_args args "$@"
    printf "\0337${CY}${BOLD}%s\0338\033[3C${CY}${BOLD}%s${NC}${args[nl]}" "${args[icon]:-$ICON_INFO}" "${args[text]}"
}

# ============================================================================
# OUTPUT ICON PROCESS MESSAGE
# ============================================================================

# Print a step with emoji 🔵 📍 ⚪⚪⚪⚪⚪
# Parameters: [-n] message [icon] [-i|--icon icon]
# -n: Do not output a trailing newline
# -i|--icon: Custom icon
print_step() {
    local -A args
    _parse_args args "$@"
    printf "\0337${CY}${BOLD}%s${NC}\0338\033[3C${NC}%s${args[nl]}" "${args[icon]:-$ICON_STEP}" "${args[text]}"
}

# Print a progress indicator 🟡 ⏳ ⚫⚫⚫⚫⚫
# Parameters: [-n] message [icon] [-i|--icon icon]
# -n: Do not output a trailing newline
# -i|--icon: Custom icon
print_progress() {
    local -A args
    _parse_args args "$@"
    printf "\0337${YL}${BOLD}%s${NC}\0338\033[3C${NC}${GR}%s${args[nl]}" "${args[icon]:-$ICON_PROGRESS}" "${args[text]}"
}

# Print a progress indicator 🟢 🏁 ⚪⚪⚪⚪⚪
# Parameters: [-n] message [icon] [-i|--icon icon]
# -n: Do not output a trailing newline
# -i|--icon: Custom icon
print_finish() {
    local -A args
    _parse_args args "$@"
    printf "\0337${GN}${BOLD}%s${NC}\0338\033[3C${NC}${BOLD}%s${args[nl]}" "${args[icon]:-$ICON_FINISHED}" "${args[text]}"
}

# Print a progress indicator ⚪ ➤ ⚪⚪⚪⚪⚪
# Parameters: [-n] message [icon] [-i|--icon icon]
# -n: Do not output a trailing newline
# -i|--icon: Custom icon
print_log() {
    local -A args
    _parse_args args "$@"
    printf "\0337${BOLD}%s${NC}\0338\033[3C${NC}%s${args[nl]}" "${args[icon]:-➤}" "${args[text]}"
}



