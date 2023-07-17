local builtin = require("telescope.builtin")

-- Picker Options: https://github.com/nvim-telescope/telescope.nvim#pickers
vim.keymap.set("n", "<leader>ff", builtin.find_files, {})
vim.keymap.set("n", "<leader>gf", builtin.git_files, {})
vim.keymap.set("n", "<leader>FF", function()
    builtin.grep_string({ search = vim.fn.input("grep > ") })
end)
