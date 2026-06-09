#!/usr/bin/env bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib.sh"

link "Register custom.sh as omarchy post-update hook" \
  "$SCRIPT_DIR/custom.sh" "$HOME/.config/omarchy/hooks/post-update.d"

"$SCRIPT_DIR/latex.sh"
"$SCRIPT_DIR/zotero.sh"
"$SCRIPT_DIR/config.sh"
