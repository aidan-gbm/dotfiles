vim.pack.add({
    {
	src = "https://github.com/nvim-telescope/telescope.nvim",
	version = "v0.2.2",
    },
    "https://github.com/nvim-lua/plenary.nvim",
    "https://github.com/nvim-telescope/telescope-ui-select.nvim",
})

ts = require("telescope")

ts.setup({})
ts.load_extension("ui-select")

local builtin = require("telescope.builtin")

vim.keymap.set("n", "<leader>ff", builtin.find_files, {})
vim.keymap.set("n", "<leader>gf", builtin.git_files, {})

vim.keymap.set("n", "<leader>gd", builtin.lsp_definitions, {})
vim.keymap.set("n", "<leader>gt", builtin.lsp_type_definitions, {})
vim.keymap.set("n", "<leader>gr", builtin.lsp_references, {})
vim.keymap.set("n", "<leader>gi", builtin.lsp_implementations, {})
vim.keymap.set("n", "<leader>gs", builtin.lsp_document_symbols, {})
vim.keymap.set("n", "<leader>gS", builtin.lsp_workspace_symbols, {})
