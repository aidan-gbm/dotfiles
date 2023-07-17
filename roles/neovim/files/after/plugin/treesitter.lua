require("nvim-treesitter.configs").setup {

    -- https://github.com/nvim-treesitter/nvim-treesitter#supported-languages
    ensure_installed = {
        "bash",
        "c",            -- required
        "cmake",
        "cpp",
        "css",
        "dockerfile",
        "go",
        "html",
        "java",
        "json",
        "lua",          -- required
        "make",
        "markdown",
        "php",
        "python",
        "query",        -- required
        "typescript",
        "vim",          -- required
        "vimdoc",       -- required
        "yaml",
    },

    sync_install = false,
    auto_install = false,   -- requires `tree-sitter` CLI
    highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
    },
}
