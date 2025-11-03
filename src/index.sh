#!/bin/bash
# Auto-load all scripts in the current directory
#
# This file sources all .sh files in the same directory except itself.
# Use this for convenience when you want all scripts loaded at once.
#
# Usage:
#   source ./src/index.sh
#   # or after bpkg install:
#   source deps/package-name/src/index.sh

# Use a function to avoid polluting the global namespace
__load_scripts() {
    local SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[1]}")" && pwd)"
    local script

    for script in "$SCRIPT_DIR"/*.sh; do
        [[ "$(basename "$script")" == "index.sh" ]] && continue
        source "$script"
    done
}

__load_scripts
unset -f __load_scripts
