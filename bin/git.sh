#!/usr/bin/env bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib.sh"

link "Launch browser with git remote" "$SCRIPT_DIR/launch-browser-git" "$HOME/.local/bin/launch-browser-git"

# Point SUPER SHIFT RETURN at launch-browser-git. Matching the whole line keeps
# the other two browser bindings (SUPER SHIFT B and SUPER SHIFT ALT B) on
# omarchy-launch-browser, and makes this a no-op once it has been applied.
bindings_file="$HOME/.config/hypr/bindings.conf"
stock_binding='bindd = SUPER SHIFT, RETURN, Browser, exec, omarchy-launch-browser'
git_binding='bindd = SUPER SHIFT, RETURN, Browser (git remote if in repo), exec, launch-browser-git'

if grep -Fxq "$git_binding" "$bindings_file"; then
  ok "Browser keybinding"
elif grep -Fxq "$stock_binding" "$bindings_file"; then
  doing "Set browser keybinding"
  STOCK_BINDING="$stock_binding" GIT_BINDING="$git_binding" perl -0pi -e 's/\Q$ENV{STOCK_BINDING}\E/$ENV{GIT_BINDING}/' "$bindings_file"
else
  abort "Browser keybinding: expected stock browser binding not found in $bindings_file"
fi
