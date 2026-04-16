vim.pack.add({
	-- colorscheme
	{
		name = "moonfly",
		src = "https://github.com/bluz71/vim-moonfly-colors",
	},

	-- LSP completion
	"https://github.com/hrsh7th/nvim-cmp",
	"https://github.com/hrsh7th/cmp-nvim-lsp",
	"https://github.com/hrsh7th/cmp-buffer",
	"https://github.com/hrsh7th/cmp-path",

	-- formatting
	"https://github.com/stevearc/conform.nvim",
})

require("plugin.treesitter")
require("plugin.telescope")
require("plugin.conform")
