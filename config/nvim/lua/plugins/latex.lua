-- See https://github.com/basecamp/omarchy/discussions/1720#discussioncomment-14599474
-- LaTeX / BibTeX workflow for LazyVim
return {
	-- Core LaTeX plugin
	{
		"lervag/vimtex",
		lazy = false, -- load immediately so *.tex work out of the box
		init = function()
			-- Use Zathura (great on Wayland; change to 'skim' on macOS)
			vim.g.vimtex_view_method = "zathura"
			vim.g.vimtex_view_forward_search_on_start = 1

			-- Compile with latexmk into ./build with synctex + nonstop mode
			vim.g.vimtex_compiler_method = "latexmk"
			vim.g.vimtex_compiler_latexmk = {
				build_dir = "build",
				options = {
					"-pdf",
					"-interaction=nonstopmode",
					"-synctex=1",
					"-file-line-error",
					"-shell-escape",
				},
			}

			-- QoL
			vim.g.vimtex_quickfix_mode = 0
			vim.g.vimtex_matchparen_enabled = 1
			vim.g.vimtex_indent_enabled = 1
			vim.g.vimtex_syntax_enabled = 1
			vim.g.vimtex_complete_enabled = 1
			vim.g.vimtex_imaps_enabled = 0
			vim.g.vimtex_view_automatic = 1
			vim.g.tex_flavor = "latex"
			vim.g.tex_conceal = "abdmg"
		end,
		keys = {
			{ "<leader>lc", "<cmd>VimtexCompile<cr>", desc = "LaTeX: Compile" },
			{ "<leader>ll", "<cmd>VimtexCompileToggle<cr>", desc = "LaTeX: Auto Compile (toggle)" },
			{ "<leader>lv", "<cmd>VimtexView<cr>", desc = "LaTeX: View PDF" },
			{ "<leader>lk", "<cmd>VimtexClean<cr>", desc = "LaTeX: Clean build" },
		},
	},

	-- Ensure LSP servers are installed by Mason
	{
		"mason-org/mason.nvim",
		opts = function(_, opts)
			opts.ensure_installed = opts.ensure_installed or {}
			vim.list_extend(opts.ensure_installed, { "texlab", "ltex-ls" })
		end,
	},

	-- LSP wiring: texlab (build/forward search) + ltex (grammar)
	{
		"neovim/nvim-lspconfig",
		opts = {
			servers = {
				texlab = {
					settings = {
						texlab = {
							auxDirectory = "build",
							build = {
								executable = "latexmk",
								args = {
									"-pdf",
									"-interaction=nonstopmode",
									"-synctex=1",
									"-file-line-error",
									"-shell-escape",
									"-outdir=build",
									"%f",
								},
								onSave = true,
								forwardSearchAfter = true,
							},
							forwardSearch = {
								executable = "zathura",
								args = { "--synctex-forward", "%l:1:%f", "%p" },
							},
							chktex = { onOpenAndSave = true, onEdit = false },
						},
					},
				},
				ltex = {
					filetypes = { "tex", "bib", "markdown" },
					settings = {
						ltex = {
							language = "en-US",
							additionalRules = { enablePickyRules = true },
							checkFrequency = "save",
						},
					},
				},
			},
		},
	},

	-- Treesitter grammars
	{
		"nvim-treesitter/nvim-treesitter",
		opts = function(_, opts)
			opts.ensure_installed = opts.ensure_installed or {}
			vim.list_extend(opts.ensure_installed, { "latex", "bibtex" })
		end,
	},

	-- Completion sources: LaTeX symbols + citations/refs (pandoc)
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			{ "kdheepak/cmp-latex-symbols" },
			{ "jc-doyle/cmp-pandoc-references", ft = { "tex", "markdown" } },
		},
		opts = function(_, opts)
			opts.sources = opts.sources or {}
			table.insert(opts.sources, { name = "latex_symbols", priority = 700 })
			table.insert(opts.sources, { name = "pandoc_references", priority = 650 })
			return opts
		end,
	},
}
