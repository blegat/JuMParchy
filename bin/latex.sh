#!/usr/bin/env bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib.sh"

ROOT_SRC="$(cd "$SCRIPT_DIR/.." && pwd)"

# See [here](https://github.com/basecamp/omarchy/discussions/1720)
omarchy-pkg-add zathura zathura-pdf-mupdf
omarchy-pkg-add texlive
link ".latexmkrc" "$ROOT_SRC/.latexmkrc" "$HOME"
# config.sh also copies
# - config/nvim/lua/plugins/latex.lua
# - config/nvim/ftplugin/tex.lua
