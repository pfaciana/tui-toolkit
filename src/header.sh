#!/usr/bin/env bash

if [[ -n "${_HEADER_LOADED:-}" ]]; then
    return 0
fi
_HEADER_LOADED=1

. "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/ansi.sh"

print_header() {
    local title=""
    local width=80
    local padding=1
    local center=false
    local closed=false
    local fit=false
    local border_prefix="${CY}"
    local cell_prefix="${BOLD}${WH}"

    # Parse arguments
    while [[ $# -gt 0 ]]; do
        case "$1" in
            -w|--width) width="$2"; shift 2 ;;
            -p|--padding) padding="$2"; shift 2 ;;
            -c|--center) center=true; shift ;;
            -d|--closed) closed=true; shift ;;
            -f|--fit) fit=true; shift ;;
            -b|--border) border_prefix="$2"; shift 2 ;;
            -t|--cell) cell_prefix="$2"; shift 2 ;;
            -*) shift ;;
            *) title="$1"; shift ;;
        esac
    done

    # Calculate dimensions
    local title_len=${#title}
    local lr_padding=$padding
    local tb_padding=$((padding > 0 ? padding - 1 : 0))

    # Calculate box width
    local box_width=$width
    if [[ "$fit" == "true" ]]; then
        box_width=$((title_len + lr_padding * 2))
    fi

    # Calculate interior width (space available for content)
    local interior_width=$((box_width - lr_padding * 2))

    # Determine if we can close the box
    local can_close=true
    if [[ $title_len -gt $interior_width ]]; then
        can_close=false
    fi

    # Create top border
    local top_border="${border_prefix}╔"
    for ((i=0; i<box_width; i++)); do top_border+="═"; done
    top_border+="╗${NC}"

    # Create bottom border
    local bottom_border="${border_prefix}╚"
    for ((i=0; i<box_width; i++)); do bottom_border+="═"; done
    bottom_border+="╝${NC}"

    # Create empty padding line
    local padding_line="${border_prefix}║${NC}"
    if [[ "$closed" == "true" && "$can_close" == "true" ]]; then
        for ((i=0; i<box_width; i++)); do padding_line+=" "; done
        padding_line+="${border_prefix}║${NC}"
    fi

    # Create title line
    local title_line="${border_prefix}║${NC}"

    # Add left padding
    for ((i=0; i<lr_padding; i++)); do title_line+=" "; done

    # Add title (aligned)
    if [[ "$center" == "true" ]]; then
        local text_padding=$(( (interior_width - title_len) / 2 ))
        for ((i=0; i<text_padding; i++)); do title_line+=" "; done
        title_line+="${cell_prefix}${title}${NC}"
        if [[ "$closed" == "true" && "$can_close" == "true" ]]; then
            for ((i=0; i<interior_width - title_len - text_padding; i++)); do title_line+=" "; done
        fi
    else
        # Left aligned
        title_line+="${cell_prefix}${title}${NC}"
        if [[ "$closed" == "true" && "$can_close" == "true" ]]; then
            for ((i=0; i<interior_width - title_len; i++)); do title_line+=" "; done
        fi
    fi

    # Add right padding and closing border if requested and possible
    if [[ "$closed" == "true" && "$can_close" == "true" ]]; then
        for ((i=0; i<lr_padding; i++)); do title_line+=" "; done
        title_line+="${border_prefix}║${NC}"
    fi

    # Print the header
    printf '\n'
    printf '%s\n' "$top_border"

    # Print top padding rows
    for ((i=0; i<tb_padding; i++)); do
        printf '%s\n' "$padding_line"
    done

    printf '%s\n' "$title_line"

    # Print bottom padding rows
    for ((i=0; i<tb_padding; i++)); do
        printf '%s\n' "$padding_line"
    done

    printf '%s\n' "$bottom_border"
}
