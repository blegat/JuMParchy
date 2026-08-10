#!/usr/bin/env bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib.sh"

# Until https://github.com/basecamp/omarchy/pull/5890 is merged
if command -v julia > /dev/null; then
    ok "julia"
else
    doing "julia"
    curl -fsSL https://install.julialang.org | sh -s -- --yes
fi

# config.sh also copies
# - config/nvim/lua/plugins/flash.lua
# - config/nvim/lua/plugins/julia-repl.lua
# - config/nvim/lua/plugins/mason-lspconfig.lua
