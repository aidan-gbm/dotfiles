vim.g.mapleader = " "

vim.keymap.set("n", "<leader>E", vim.cmd.Ex)
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float)

-- move visual blocks
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '>-2<CR>gv=gv")

-- center cursor
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "<C-d>", "<C-d>zz")

-- telescope
vim.cmd [[packadd telescope.nvim]]
require("telescope").setup({})

local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>ff", builtin.find_files, {})
vim.keymap.set("n", "<leader>gf", builtin.git_files, {})
