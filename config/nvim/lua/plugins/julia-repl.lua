return {
	{
		"klafyvel/nvim-smuggler",
		enabled = vim.env.NVIM_NO_SMUGGLER ~= "1",
		ft = "julia",
		dependencies = { "nvim-neotest/nvim-nio" },
		opts = {
			ui = {
				mappings = {
					smuggle = "<S-CR>", -- normal mode: send line
					smuggle_range = "<S-CR>", -- visual mode: send selection
					smuggle_config = "<leader>jc", -- connect to socket
					smuggle_operator = "gcs", -- keep default operator
				},
			},
			buffers = {
				-- Evaluate multi-line sends as one REPL entry (VS Code-like).
				eval_by_blocks = true,
			},
		},
		config = function(_, opts)
			require("smuggler").setup(opts)

			-- Find the top-level expression (child of `source_file`) that contains
			-- the cursor. Falls back to nil if treesitter is unavailable.
			local function toplevel_range()
				local ok, parser = pcall(vim.treesitter.get_parser, 0, "julia")
				if not ok or not parser then
					return nil
				end
				local root = parser:parse()[1]:root()
				local row = vim.api.nvim_win_get_cursor(0)[1] - 1
				local node = root:named_descendant_for_range(row, 0, row, 0)
				if not node then
					return nil
				end
				while node:parent() and node:parent():id() ~= root:id() do
					node = node:parent()
				end
				local sr, _, er, ec = node:range()
				-- If the node ends at column 0 of er, it actually ends on the previous line.
				if ec == 0 then
					er = er - 1
				end
				return sr + 1, er + 1
			end

			local function advance_to(line)
				local total = vim.api.nvim_buf_line_count(0)
				vim.api.nvim_win_set_cursor(0, { math.min(line + 1, total), 0 })
			end

			vim.keymap.set("n", "<S-CR>", function()
				local sr, er = toplevel_range()
				if sr and er and er > sr then
					vim.cmd(string.format("%d,%dSmuggleRange", sr, er))
					advance_to(er)
				else
					-- Single-line statement (or no treesitter) — send current line.
					local count = vim.v.count1
					vim.cmd(count .. "Smuggle")
					vim.cmd("normal! " .. count .. "j")
				end
			end, { desc = "Smuggle: send enclosing block and advance" })

			vim.keymap.set("x", "<S-CR>", function()
				-- Leaving visual mode sets the '< and '> marks.
				local last = vim.fn.getpos("'>")[2]
				vim.cmd("'<,'>SmuggleRange")
				advance_to(last)
			end, { desc = "Smuggle: send selection and advance" })
		end,
		keys = {
			-- These just trigger lazy-loading on first press in a .jl file.
			-- The actual mappings are created by smuggler's setup above.
			{ "<S-CR>", ft = "julia", mode = { "n", "v" }, desc = "Smuggle" },
			{ "<leader>jc", ft = "julia", desc = "Smuggle: connect" },
		},
	},
}
