#!/usr/bin/env bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib.sh"
omarchy-pkg-add podman
omarchy-pkg-add opencode

bindings_file="$HOME/.config/hypr/bindings.conf"
grok_binding='bindd = SUPER SHIFT ALT, A, Grok, exec, omarchy-launch-webapp "https://grok.com"'
opencode_binding='bindd = SUPER SHIFT ALT, A, Opencode, exec, uwsm-app -- xdg-terminal-exec -- opencode'

if grep -Fxq "$opencode_binding" "$bindings_file"; then
  ok "Opencode keybinding"
elif grep -Fxq "$grok_binding" "$bindings_file"; then
  doing "Set Opencode keybinding"
  GROK_BINDING="$grok_binding" perl -0pi -e 's/\Q$ENV{GROK_BINDING}\E/bindd = SUPER SHIFT ALT, A, Opencode, exec, uwsm-app -- xdg-terminal-exec -- opencode/' "$bindings_file"
else
  fail "Opencode keybinding: expected Grok binding not found in $bindings_file"
  exit 1
fi
