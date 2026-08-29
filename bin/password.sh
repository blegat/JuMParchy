#!/usr/bin/env bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib.sh"

bindings="$HOME/.config/hypr/bindings.lua"
unbind_line='hl.unbind("SUPER + SHIFT + SLASH")'
bind_line='o.bind("SUPER + SHIFT + SLASH", "Passwords", { launch = "bitwarden" })'
bindings_changed=0

omarchy-pkg-add bitwarden

if [[ ! -f $bindings ]] || ! grep -Fxq "$unbind_line" "$bindings"; then
  bindings_changed=1
fi
ensure_line "Unbind the default 1Password shortcut" \
  "$bindings" "$unbind_line"

if [[ ! -f $bindings ]] || ! grep -Fxq "$bind_line" "$bindings"; then
  bindings_changed=1
fi
ensure_line "Bind the password shortcut to Bitwarden" \
  "$bindings" "$bind_line"

if (( bindings_changed )); then
  hyprctl reload >/dev/null

  config_errors=$(hyprctl configerrors)
  if [[ -n $config_errors ]]; then
    fail "Hyprland configuration errors:"
    printf '%s\n' "$config_errors" >&2
    exit 1
  fi
fi
