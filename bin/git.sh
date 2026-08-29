#!/usr/bin/env bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib.sh"

# Otherwise it does not even let me try `git pull` if it's not clean and I need to constantly stash
# even if the `git pull` where probably just going to tell me I am up to date
git config --global --unset-all pull.rebase || [ "$?" -eq 5 ]
git config --global pull.ff only

link "Launch browser with git remote" "$SCRIPT_DIR/launch-browser-git" "$HOME/.local/bin/launch-browser-git"

ensure_keybinding "Open the current Git remote from the browser shortcut" \
  "SUPER + SHIFT + RETURN" \
  'o.bind("SUPER + SHIFT + RETURN", "Browser (git remote if in repo)", "launch-browser-git")'
