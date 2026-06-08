#!/usr/bin/env bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib.sh"

link "Register custom.sh as omarchy post-update hook" \
  "$SCRIPT_DIR/custom.sh" "$HOME/.config/omarchy/hooks/post-update.d/custom.sh"

"$SCRIPT_DIR/config.sh"
"$SCRIPT_DIR/zotero.sh"
