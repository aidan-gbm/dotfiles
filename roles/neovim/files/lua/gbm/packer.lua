vim.cmd [[packadd packer.nvim]]

return require("packer").startup({ function(use)

    -- Let Packer manage itself
    use("wbthomason/packer.nvim")

    -- Theme
    -- use("olimorris/onedarkpro.nvim")
    use("bluz71/vim-nightfly-colors")
    use {
        "nvim-lualine/lualine.nvim",
        requires = {
            { "nvim-tree/nvim-web-devicons", opt = true },
        }
    }

    -- Navigation
    use {
        "nvim-telescope/telescope.nvim",
        tag = "0.1.1",
        requires = {
            { "nvim-lua/plenary.nvim" },
        }
    }

    -- tree-sitter
    use {
        "nvim-treesitter/nvim-treesitter",
        run = function()
            local ts_update = require("nvim-treesitter.install").update({
                with_sync = true
            })
            ts_update()
        end,
    }

    use("nvim-treesitter/nvim-treesitter-context")

    -- LSP
    use("hrsh7th/nvim-cmp")
    use("L3MON4D3/LuaSnip")
    use("hrsh7th/cmp-nvim-lsp")
    use("neovim/nvim-lspconfig")
    use("williamboman/mason.nvim")
    use("williamboman/mason-lspconfig.nvim")

    -- Python Fixes
    use("Vimjas/vim-python-pep8-indent")

end,
config = {
    git = {
        -- Override for different git origin
        default_url_format = "https://github.com/%s",
    },
}})
