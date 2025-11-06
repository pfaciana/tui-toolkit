#!/usr/bin/env bash

if [[ -n "${_ANSI_LOADED:-}" ]]; then
    return 0
fi
_ANSI_LOADED=1

# ============================================================================
# COLORS AND FORMATTING
# ============================================================================

# Color codes (foreground)
readonly WH=$'\033[0;37m'
readonly GR=$'\033[0;90m'
readonly BK=$'\033[0;30m'
readonly RD=$'\033[0;31m'
readonly GN=$'\033[0;32m'
readonly YL=$'\033[0;33m'
readonly BL=$'\033[0;34m'
readonly MG=$'\033[0;35m'
readonly CY=$'\033[0;36m'

# Background colors
readonly BG_WH=$'\033[47m'
readonly BG_GR=$'\033[100m'
readonly BG_BK=$'\033[40m'
readonly BG_RD=$'\033[41m'
readonly BG_GN=$'\033[42m'
readonly BG_YL=$'\033[43m'
readonly BG_BL=$'\033[44m'
readonly BG_MG=$'\033[45m'
readonly BG_CY=$'\033[46m'

# Text formatting
readonly NC=$'\033[0m'
readonly BOLD=$'\033[1m'
readonly DIM=$'\033[2m'

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

