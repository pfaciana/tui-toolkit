#!/usr/bin/env bash

if [[ -n "${_TABLE_LOADED:-}" ]]; then
    return 0
fi
_TABLE_LOADED=1

declare -a _TABLE_DATA=()
declare -a _TABLE_WIDTHS=()
declare -a _TABLE_ALIGNMENTS=()
declare -i _TABLE_MARGIN=1
declare -i _TABLE_PADDING=0
declare _TABLE_CENTER_HEADERS=false
declare _TABLE_BORDER_PREFIX=""
declare _TABLE_CELL_PREFIX=""
declare -i _TABLE_MAX_WIDTH=25
declare _TABLE_ELLIPSIS="…"
declare -i _TABLE_HEADER_COUNT=0
declare -i _TABLE_LINES_PRINTED=0
declare _TABLE_IN_REDRAW=false
declare -i _TABLE_MESSAGE_LINES=0

strip_ansi() {
    local text="$1"
    echo -n "$text" | sed -E 's/\x1b\[[0-9;]*m//g'
}

visible_length() {
    local stripped
    stripped=$(strip_ansi "$1")
    echo -n "${#stripped}"
}

wrap_cell_content() {
    local content="$1"
    local prefix="$2"

    if [[ -z "$prefix" ]]; then
        printf '%s' "$content"
        return
    fi

    local esc=$'\033'
    local result="$content"

    result="${result//${esc}[0;/${esc}[0m${prefix}${esc}[}"
    result="${result//${esc}[0m/${esc}[0m${prefix}}"
    #"# This forces the base style (in prefix) to survive any ANSI reset inside

    printf '%s' "$result"
}

print_table_start() {
    _TABLE_DATA=()
    _TABLE_WIDTHS=()
    _TABLE_ALIGNMENTS=()
    _TABLE_MARGIN=1
    _TABLE_PADDING=0
    _TABLE_CENTER_HEADERS=false
    _TABLE_BORDER_PREFIX=""
    _TABLE_CELL_PREFIX=""
    _TABLE_MAX_WIDTH=25
    _TABLE_ELLIPSIS="…"
    _TABLE_HEADER_COUNT=0
    _TABLE_LINES_PRINTED=0
    _TABLE_IN_REDRAW=false
    _TABLE_MESSAGE_LINES=0

    while [[ $# -gt 0 ]]; do
        case "$1" in
            -m|--margin) _TABLE_MARGIN="$2"; shift 2 ;;
            -p|--padding) _TABLE_PADDING="$2"; shift 2 ;;
            -c|--center) _TABLE_CENTER_HEADERS=true; shift ;;
            -b|--border) _TABLE_BORDER_PREFIX="$2"; shift 2 ;;
            -t|--cell) _TABLE_CELL_PREFIX="$2"; shift 2 ;;
            -w|--max-width) _TABLE_MAX_WIDTH="$2"; shift 2 ;;
            -e|--ellipsis) _TABLE_ELLIPSIS="$2"; shift 2 ;;
            *) shift ;;
        esac
    done
}

parse_alignment() {
    local text="$1"
    local align="left"
    local clean="$text"

    if [[ "$text" == :*: ]]; then
        align="center"
        clean="${text:1:${#text}-2}"
    elif [[ "$text" == *: ]]; then
        align="right"
        clean="${text:0:${#text}-1}"
    elif [[ "$text" == :* ]]; then
        align="left"
        clean="${text:1}"
    fi

    echo "$align|$clean"
}

update_column_widths() {
    local col_count=$1
    local parse_align=$2
    shift 2
    local -a cells=("$@")

    for ((i=0; i<col_count; i++)); do
        local cell="${cells[i]:-}"
        local clean="$cell"

        if [[ "$parse_align" == "true" ]]; then
            local parsed
            parsed=$(parse_alignment "$cell")
            clean="${parsed#*|}"
        fi

        local visible_len
        visible_len=$(visible_length "$clean")

        if [[ $visible_len -gt $_TABLE_MAX_WIDTH ]]; then
            visible_len=$_TABLE_MAX_WIDTH
        fi

        if [[ -z "${_TABLE_WIDTHS[i]:-}" ]] || [[ $visible_len -gt ${_TABLE_WIDTHS[i]} ]]; then
            _TABLE_WIDTHS[i]=$visible_len
        fi
    done
}

erase_table() {
    if [[ $_TABLE_LINES_PRINTED -gt 0 ]]; then
        for ((i=0; i<_TABLE_LINES_PRINTED; i++)); do
            printf '\033[A\033[2K'
        done
    fi
}

erase_messages() {
    for ((i=0; i<_TABLE_MESSAGE_LINES; i++)); do
        printf '\033[A\033[2K'
    done
    _TABLE_MESSAGE_LINES=0
}

print_divider() {
    local left="$1"
    local middle="$2"
    local cross="$3"
    local right="$4"

    printf '%s%s' "$_TABLE_BORDER_PREFIX" "$left"
    for ((i=0; i<${#_TABLE_WIDTHS[@]}; i++)); do
        local width=$((_TABLE_WIDTHS[i] + _TABLE_MARGIN * 2 + _TABLE_PADDING * 2))
        for ((j=0; j<width; j++)); do
            printf '%s' "$middle"
        done
        if [[ $i -lt $((${#_TABLE_WIDTHS[@]} - 1)) ]]; then
            printf '%s' "$cross"
        fi
    done
    printf '%s\033[0m\n' "$right"
    ((_TABLE_LINES_PRINTED++))
}

align_text() {
    local text="$1"
    local width="$2"
    local align="$3"
    local visible_len
    visible_len=$(visible_length "$text")

    if [[ $visible_len -gt $_TABLE_MAX_WIDTH ]]; then
        local stripped
        stripped=$(strip_ansi "$text")
        local truncate_len=$((_TABLE_MAX_WIDTH - ${#_TABLE_ELLIPSIS}))
        text="${stripped:0:$truncate_len}${_TABLE_ELLIPSIS}"
        visible_len=$_TABLE_MAX_WIDTH
    fi

    local padding=$((width - visible_len))

    if [[ "$align" == "center" ]]; then
        local left_pad=$((padding / 2))
        local right_pad=$((padding - left_pad))
        printf '%*s%s%*s' "$left_pad" '' "$text" "$right_pad" ''
    elif [[ "$align" == "right" ]]; then
        printf '%*s%s' "$padding" '' "$text"
    else
        printf '%s%*s' "$text" "$padding" ''
    fi
}

print_cell() {
    local content="$1"
    local width="$2"
    local align="$3"

    [[ $_TABLE_MARGIN -gt 0 ]] && printf '%s%*s\033[0m' "$_TABLE_BORDER_PREFIX" "$_TABLE_MARGIN" ''
    [[ $_TABLE_PADDING -gt 0 ]] && printf '%s%*s\033[0m' "$_TABLE_CELL_PREFIX" "$_TABLE_PADDING" ''

    local wrapped
    wrapped=$(wrap_cell_content "$content" "$_TABLE_CELL_PREFIX")
    printf '%s' "$_TABLE_CELL_PREFIX"
    align_text "$wrapped" "$width" "$align"
    printf '\033[0m'

    [[ $_TABLE_PADDING -gt 0 ]] && printf '%s%*s\033[0m' "$_TABLE_CELL_PREFIX" "$_TABLE_PADDING" ''
    [[ $_TABLE_MARGIN -gt 0 ]] && printf '%s%*s\033[0m' "$_TABLE_BORDER_PREFIX" "$_TABLE_MARGIN" ''
}

print_row_generic() {
    local is_header="$1"
    shift
    local -a cells=("$@")

    printf '%s│\033[0m' "$_TABLE_BORDER_PREFIX"
    for ((i=0; i<${#_TABLE_WIDTHS[@]}; i++)); do
        local cell="${cells[i]:-}"
        local align="left"

        if [[ "$is_header" == "true" ]]; then
            [[ "$_TABLE_CENTER_HEADERS" == true ]] && align="center"
        else
            align="${_TABLE_ALIGNMENTS[i]:-left}"
        fi

        print_cell "$cell" "${_TABLE_WIDTHS[i]}" "$align"
        printf '%s│\033[0m' "$_TABLE_BORDER_PREFIX"
    done
    printf '\n'
    ((_TABLE_LINES_PRINTED++))
}

print_header_row() {
    local -a headers=("$@")
    local -a clean_headers=()

    for ((i=0; i<${#headers[@]}; i++)); do
        local parsed
        parsed=$(parse_alignment "${headers[i]}")
        clean_headers[i]="${parsed#*|}"
    done

    print_row_generic true "${clean_headers[@]}"
}

print_row() {
    print_row_generic false "$@"
}

redraw_table() {
    if [[ "$_TABLE_IN_REDRAW" == true ]]; then
        return
    fi
    _TABLE_IN_REDRAW=true

    erase_table
    _TABLE_LINES_PRINTED=0

    print_divider "┌" "─" "┬" "┐"

    if [[ $_TABLE_HEADER_COUNT -gt 0 ]]; then
        local -a clean_headers=()

        for ((i=0; i<_TABLE_HEADER_COUNT; i++)); do
            local parsed
            parsed=$(parse_alignment "${_TABLE_DATA[i]}")
            clean_headers[i]="${parsed#*|}"
            _TABLE_ALIGNMENTS[i]="${parsed%%|*}"
        done

        print_row_generic true "${clean_headers[@]}"
        print_divider "├" "─" "┼" "┤"
    fi

    local row_start=$_TABLE_HEADER_COUNT
    local row_count=$(((${#_TABLE_DATA[@]} - _TABLE_HEADER_COUNT) / ${#_TABLE_WIDTHS[@]}))

    for ((r=0; r<row_count; r++)); do
        local -a row_cells=()
        for ((c=0; c<${#_TABLE_WIDTHS[@]}; c++)); do
            local idx=$((row_start + r * ${#_TABLE_WIDTHS[@]} + c))
            row_cells[c]="${_TABLE_DATA[idx]:-}"
        done

        if [[ "${row_cells[0]}" == "__TABLE_DIVIDER__" ]]; then
            print_divider "├" "─" "┼" "┤"
        elif [[ "${row_cells[0]}" =~ ^__TABLE_HEADER__ ]]; then
            print_divider "├" "─" "┼" "┤"
            row_cells[0]="${row_cells[0]#__TABLE_HEADER__}"

            for ((c=0; c<${#row_cells[@]}; c++)); do
                local parsed
                parsed=$(parse_alignment "${row_cells[c]}")
                _TABLE_ALIGNMENTS[c]="${parsed%%|*}"
            done

            print_header_row "${row_cells[@]}"
            print_divider "├" "─" "┼" "┤"
        else
            print_row "${row_cells[@]}"
        fi
    done

    _TABLE_IN_REDRAW=false
}

print_table_headers() {
    erase_messages

    local -a headers=("$@")
    local col_count=${#headers[@]}

    if [[ ${#_TABLE_WIDTHS[@]} -eq 0 ]]; then
        _TABLE_HEADER_COUNT=$col_count
        for ((i=0; i<col_count; i++)); do
            _TABLE_DATA[i]="${headers[i]}"
            local parsed
            parsed=$(parse_alignment "${headers[i]}")
            _TABLE_ALIGNMENTS[i]="${parsed%%|*}"
        done
        update_column_widths "$col_count" true "${headers[@]}"
        redraw_table
    else
        local needs_redraw=false
        for ((i=0; i<col_count; i++)); do
            local parsed
            parsed=$(parse_alignment "${headers[i]}")
            local clean="${parsed#*|}"
            local visible_len
            visible_len=$(visible_length "$clean")

            if [[ $visible_len -gt ${_TABLE_WIDTHS[i]} ]]; then
                needs_redraw=true
            fi

            _TABLE_DATA[${#_TABLE_DATA[@]}]="${headers[i]}"
            if [[ $i -eq 0 ]]; then
                _TABLE_DATA[$((${#_TABLE_DATA[@]} - 1))]="__TABLE_HEADER__${headers[i]}"
            fi
            _TABLE_ALIGNMENTS[i]="${parsed%%|*}"
        done

        if [[ "$needs_redraw" == true ]]; then
            update_column_widths "$col_count" true "${headers[@]}"
            redraw_table
        else
            print_divider "├" "─" "┼" "┤"
            print_header_row "${headers[@]}"
            print_divider "├" "─" "┼" "┤"
        fi
    fi
}

print_table_row() {
    local -a cells=("$@")
    local col_count=${#_TABLE_WIDTHS[@]}

    if [[ $col_count -eq 0 ]]; then
        col_count=${#cells[@]}
        for ((i=0; i<col_count; i++)); do
            _TABLE_WIDTHS[i]=0
            _TABLE_ALIGNMENTS[i]="left"
        done
    fi

    local needs_redraw=false

    if [[ $_TABLE_MESSAGE_LINES -gt 0 ]]; then
        needs_redraw=true
    fi

    for ((i=0; i<col_count; i++)); do
        local cell="${cells[i]:-}"
        local visible_len
        visible_len=$(visible_length "$cell")

        if [[ $visible_len -gt $_TABLE_MAX_WIDTH ]]; then
            visible_len=$_TABLE_MAX_WIDTH
        fi

        if [[ $visible_len -gt ${_TABLE_WIDTHS[i]} ]]; then
            needs_redraw=true
            break
        fi
    done

    for ((i=0; i<col_count; i++)); do
        _TABLE_DATA[${#_TABLE_DATA[@]}]="${cells[i]:-}"
    done

    if [[ "$needs_redraw" == true ]]; then
        erase_messages
        update_column_widths "$col_count" false "${cells[@]}"
        redraw_table
    else
        print_row "${cells[@]}"
    fi
}

print_table_divider() {
    erase_messages

    local col_count=${#_TABLE_WIDTHS[@]}
    if [[ $col_count -eq 0 ]]; then
        return
    fi

    for ((i=0; i<col_count; i++)); do
        if [[ $i -eq 0 ]]; then
            _TABLE_DATA[${#_TABLE_DATA[@]}]="__TABLE_DIVIDER__"
        else
            _TABLE_DATA[${#_TABLE_DATA[@]}]=""
        fi
    done

    print_divider "├" "─" "┼" "┤"
}

print_table_end() {
    erase_messages
    print_divider "└" "─" "┴" "┘"
}

print_table_message() {
    erase_messages
    local message="$1"
    echo "$message"
    _TABLE_MESSAGE_LINES=1
}

print_table_cleanup() {
    unset _TABLE_DATA
    unset _TABLE_WIDTHS
    unset _TABLE_ALIGNMENTS
    unset _TABLE_MARGIN
    unset _TABLE_PADDING
    unset _TABLE_CENTER_HEADERS
    unset _TABLE_BORDER_PREFIX
    unset _TABLE_CELL_PREFIX
    unset _TABLE_MAX_WIDTH
    unset _TABLE_ELLIPSIS
    unset _TABLE_HEADER_COUNT
    unset _TABLE_LINES_PRINTED
    unset _TABLE_IN_REDRAW
    unset _TABLE_MESSAGE_LINES
}

