vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

vim.keymap.set("n", "<leader>E", vim.cmd.Ex)
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float)

-- move visual blocks
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '>-2<CR>gv=gv")

-- center cursor
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "<C-d>", "<C-d>zz")

-- terminal
vim.keymap.set("n", "<leader>%", ":vsplit term://bash<CR>:set nonumber nornu<CR>i")
vim.keymap.set("n", "<leader>\"", ":split term://bash<CR>:set nonumber nornu<CR>i")
vim.keymap.set("t", "<ESC>", "<C-\\><C-N>", { noremap = true })
