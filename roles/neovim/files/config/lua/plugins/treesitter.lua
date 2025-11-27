local setup = function()
    require("nvim-treesitter.configs").setup({
        ensure_installed = {
            "bash",
            "c",
            "go",
            "lua",
            "python",
            "vim",
            "vimdoc",
        },
        sync_install = false,
        indent = { enable = true },
        highlight = { enable = true },
    })
end

return {
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        lazy = false,
        config = setup,
    }
}
