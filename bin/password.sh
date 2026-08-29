#!/usr/bin/env bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib.sh"

omarchy-pkg-add bitwarden

ensure_keybinding "Use Bitwarden for passwords" \
  "SUPER + SHIFT + SLASH" \
  'o.bind("SUPER + SHIFT + SLASH", "Passwords", { launch = "bitwarden" })'
