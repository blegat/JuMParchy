#!/usr/bin/env bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib.sh"

link "Launch browser with git remote" "$SCRIPT_DIR/launch-browser-git" "$HOME/.local/bin/launch-browser-git"
