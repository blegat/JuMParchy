#!/usr/bin/env bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_SRC="$(cd "$SCRIPT_DIR/.." && pwd)"
source "$SCRIPT_DIR/lib.sh"

reset_default "Clear default omarchy screensaver branding" \
  "$HOME/.config/omarchy/branding/screensaver.txt" \
  "$HOME/.local/share/omarchy/logo.txt"

link "Use JuMP logo as screensaver" \
  "$ROOT_SRC/logo/JuMP_logo.txt" "$HOME/.config/omarchy/branding/screensaver.txt"

ensure_line "Source profile.sh from ~/.bashrc" \
  "$HOME/.bashrc" "source $ROOT_SRC/profile.sh"

omarchy-pkg-add inkscape
omarchy-pkg-add vlc vlc-plugin-ffmpeg

"$SCRIPT_DIR/git.sh"
"$SCRIPT_DIR/julia.sh"
"$SCRIPT_DIR/latex.sh"
"$SCRIPT_DIR/zotero.sh"
"$SCRIPT_DIR/password.sh"
"$SCRIPT_DIR/config.sh"
