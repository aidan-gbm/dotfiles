vim.cmd.packadd("packer.nvim")

return require("packer").startup(function(use)
  -- Packer can manage itself
  use ("wbthomason/packer.nvim")

  use {
	  "nvim-telescope/telescope.nvim",
      tag = "0.1.1",
	  requires = {
          {"nvim-lua/plenary.nvim"}
      }
  }
  
  use {
      "nvim-treesitter/nvim-treesitter",
      run = function()
          local ts_update = require("nvim-treesitter.install").update({
              with_sync = true
          })
          ts_update()
      end
  }

  use("nvim-treesitter/nvim-treesitter-context")

  use {
      "nvim-lualine/lualine.nvim",
      requires = { "nvim-tree/nvim-web-devicons", opt = true }
  }

  use {
      "VonHeikemen/lsp-zero.nvim",
      branch = "v2.x",
      requires = {
          -- LSP Support
          {"neovim/nvim-lspconfig"},             -- Required
          {                                      -- Optional
          "williamboman/mason.nvim",
          run = function()
              pcall(vim.cmd, "MasonUpdate")
          end,
          },
          {"williamboman/mason-lspconfig.nvim"}, -- Optional

          -- Autocompletion
          {"hrsh7th/nvim-cmp"},     -- Required
          {"hrsh7th/cmp-nvim-lsp"}, -- Required
          {"L3MON4D3/LuaSnip"},     -- Required
      }
  }

  use ("olimorris/onedarkpro.nvim")

  use ("Vimjas/vim-python-pep8-indent")

end)
