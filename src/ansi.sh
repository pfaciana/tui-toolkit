#!/usr/bin/env bash

if [[ -n "${_ANSI_LOADED:-}" ]]; then
    return 0
fi
_ANSI_LOADED=1

# ============================================================================
# COLORS AND FORMATTING
# ============================================================================

# Color codes (foreground)
readonly BK=$'\033[0;30m'
readonly RD=$'\033[0;31m'
readonly GN=$'\033[0;32m'
readonly YL=$'\033[0;33m'
readonly BL=$'\033[0;34m'
readonly MG=$'\033[0;35m'
readonly CY=$'\033[0;36m'
readonly WH=$'\033[0;37m'
readonly GR=$'\033[0;90m'

# Bright colors (foreground)
readonly BRT_BK=$'\033[90m'
readonly BRT_RD=$'\033[91m'
readonly BRT_GN=$'\033[92m'
readonly BRT_YL=$'\033[93m'
readonly BRT_BL=$'\033[94m'
readonly BRT_MG=$'\033[95m'
readonly BRT_CY=$'\033[96m'
readonly BRT_WH=$'\033[97m'

# Background colors
readonly BG_BK=$'\033[40m'
readonly BG_RD=$'\033[41m'
readonly BG_GN=$'\033[42m'
readonly BG_YL=$'\033[43m'
readonly BG_BL=$'\033[44m'
readonly BG_MG=$'\033[45m'
readonly BG_CY=$'\033[46m'
readonly BG_WH=$'\033[47m'
readonly BG_GR=$'\033[100m'

# Bright background colors
readonly BG_BRT_BK=$'\033[100m'
readonly BG_BRT_RD=$'\033[101m'
readonly BG_BRT_GN=$'\033[102m'
readonly BG_BRT_YL=$'\033[103m'
readonly BG_BRT_BL=$'\033[104m'
readonly BG_BRT_MG=$'\033[105m'
readonly BG_BRT_CY=$'\033[106m'
readonly BG_BRT_WH=$'\033[107m'

# Text formatting
readonly NC=$'\033[0m' # No CSI attributes

readonly BOLD=$'\033[1m'   # Bold
readonly DIM=$'\033[2m'   # Dim/Faint
readonly ITALIC=$'\033[3m'   # Italic
readonly UNDERLINE=$'\033[4m'   # Underline
readonly BLINK=$'\033[5m'   # Slow blink
readonly SWAP=$'\033[7m'   # Reverse/Inverse
readonly STRIKE=$'\033[9m'   # Strikethrough

readonly NO_BOLD=$'\033[22m'  # Normal intensity (not bold/dim)
readonly NO_DIM=$'\033[22m'  # Normal intensity (not bold/dim)
readonly NO_ITALIC=$'\033[23m'  # Not italic
readonly NO_UNDERLINE=$'\033[24m'  # Not underlined
readonly NO_BLINK=$'\033[25m'  # Not blinking
readonly NO_SWAP=$'\033[27m'  # Not reversed
readonly NO_STRIKE=$'\033[29m'  # Not strikethrough


# ============================================================================
# CURSOR MOVEMENT
# ============================================================================

# delete the previous N lines (as if never printed), ending at the top of the removed block
delete_lines() {
  local n=${1:-1}
  if   (( n > 0 )); then printf '\e[%dF\e[%dM' "$n" "$n"      # up N, delete N
  elif (( n < 0 )); then printf '\e[1E\e[%dM'  "$((-n))"      # down 1, delete |N|
  else                   printf '\e[2K'                       # clear current line
  fi
}

# alias for deleting only one line
delete_line(){ delete_lines 1; }

# alias for deleting current line
clear_current_line(){ delete_lines 0; }


# ============================================================================
# ICONS AND EMOJIS
# ============================================================================

readonly ICON_SUCCESS="✓"
readonly ICON_ERROR="✗"
readonly ICON_INFO="ℹ"
readonly ICON_WARNING="⚠"
readonly ICON_PROGRESS="⏳"
readonly ICON_STEP="📍"
readonly ICON_FINISHED="🏁"
