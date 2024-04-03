require("gbm.set")
require("gbm.map")

require("lazy").setup({
    { "bluz71/vim-moonfly-colors", name = "moonfly", lazy = false, priority = 1000 },

    -- LSP
    { "neovim/nvim-lspconfig" },

    -- Autocomplete
    { "hrsh7th/cmp-nvim-lsp" },
    { "hrsh7th/nvim-cmp" },

    -- Snippets
    { "L3MON4D3/LuaSnip", tag = "v2.2.0" },
    { "saadparwaiz1/cmp_luasnip" },

    -- Fuzzy Finder
    {
        "nvim-telescope/telescope.nvim",
        tag = "0.1.6",
        dependencies = {
            { "nvim-lua/plenary.nvim" },
        },
        config = function()
            require("telescope").setup({})
            local builtin = require("telescope.builtin")

            -- https://github.com/nvim-telescope/telescope.nvim#pickers
            vim.keymap.set("n", "<leader>ff", builtin.find_files, {})
            vim.keymap.set("n", "<leader>gf", builtin.git_files, {})
            vim.keymap.set("n", "<leader>fo", builtin.oldfiles, {})
        end
    },
})

vim.cmd.colorscheme("moonfly")
