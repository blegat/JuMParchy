#!/usr/bin/env bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib.sh"

bindings="$HOME/.config/hypr/bindings.lua"

omarchy-pkg-add bitwarden

ensure_line "Unbind the default 1Password shortcut" \
  "$bindings" 'hl.unbind("SUPER + SHIFT + SLASH")'

ensure_line "Bind the password shortcut to Bitwarden" \
  "$bindings" 'o.bind("SUPER + SHIFT + SLASH", "Passwords", { launch = "bitwarden" })'

hyprctl reload
hyprctl configerrors
