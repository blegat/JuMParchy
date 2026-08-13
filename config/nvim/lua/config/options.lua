-- [REPLACES_COPY_OF] /usr/share/omarchy-nvim/config/lua/config/options.lua

-- The stock options.lua requires sibling modules from the package tree, but
-- omarchy-nvim-setup only seeds ~/.config/nvim when it doesn't exist yet, so
-- modules added by later package updates never land there. Make the package's
-- lua dir a fallback for require; ~/.config/nvim still wins via runtimepath.
package.path = "/usr/share/omarchy-nvim/config/lua/?.lua;" .. package.path

dofile("/usr/share/omarchy-nvim/config/lua/config/options.lua")

vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = true
