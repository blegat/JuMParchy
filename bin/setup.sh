#!/usr/bin/env bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib.sh"

link "Register custom.sh as omarchy post-update hook" \
  "$SCRIPT_DIR/custom.sh" "$HOME/.config/omarchy/hooks/post-update.d/custom.sh"

link "Switching blink.cmp from 'enter' preset to 'super-tab' (Tab accepts, Enter inserts newline)" \
  "$SCRIPT_DIR/blink.lua" "$HOME/.config/nvim/lua/plugins/blink.lua"

"$SCRIPT_DIR/zotero.sh"
