-- The default in `omarchy` is the `enter` preset.
-- For accepting auto-complete suggestions, this preset require <enter>. Two issues with this
-- It is not consistent with VS-code which uses TAB
-- When at the end of a line, I press <enter> to get a newline and it
-- then accepts the auto-complete, this is annoying
return {
	"saghen/blink.cmp",
	opts = {
		keymap = { preset = "super-tab" },
	},
}
