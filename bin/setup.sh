#!/usr/bin/env bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib.sh"

link "Switching blink.cmp from 'enter' preset to 'super-tab' (Tab accepts, Enter inserts newline)" \
  "$SCRIPT_DIR/blink.lua" "$HOME/.config/nvim/lua/plugins/blink.lua"

"$SCRIPT_DIR/zotero.sh"
