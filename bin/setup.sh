#!/usr/bin/env bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_SRC="$(cd "$SCRIPT_DIR/.." && pwd)"
source "$SCRIPT_DIR/lib.sh"

link "Register custom.sh as omarchy post-update hook" \
  "$SCRIPT_DIR/custom.sh" "$HOME/.config/omarchy/hooks/post-update.d"

ensure_line "Source profile.sh from ~/.bashrc" \
  "$HOME/.bashrc" "source $ROOT_SRC/profile.sh"

reset_default "Clear unmodified default alacritty.toml so config.sh can symlink" \
  "$HOME/.config/alacritty/alacritty.toml" \
  "$HOME/.local/share/omarchy/config/alacritty/alacritty.toml"

reset_default "Clear default nvim options.lua so config.sh can symlink" \
  "$HOME/.config/nvim/lua/config/options.lua" \
  "/usr/share/omarchy-nvim/config/lua/config/options.lua"

"$SCRIPT_DIR/julia.sh"
"$SCRIPT_DIR/latex.sh"
"$SCRIPT_DIR/zotero.sh"
"$SCRIPT_DIR/config.sh"
