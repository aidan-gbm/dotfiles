local servers = {
    clangd = true,
    gopls = true,
    jedi_language_server = true,
    terraformls = true,
}

vim.filetype.add({
    extension = {
        tf = "terraform",
    }
})

local attach = function(args)
    local bufnr = args.buf
    local client = assert(
        vim.lsp.get_client_by_id(args.data.client_id),
        "no valid client"
    )

    vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"

    local opts = { buffer = bufnr }
    local builtin = require("telescope.builtin")
    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
    vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)

    vim.keymap.set("n", "gd", builtin.lsp_definitions, opts)
    vim.keymap.set("n", "gr", builtin.lsp_references, opts)
    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
    vim.keymap.set("n", "gt", vim.lsp.buf.type_definition, opts)

    if client.supports_method("textDocument/formatting") then
        vim.api.nvim_create_autocmd("BufWritePre", {
            buffer = bufnr,
            callback = function()
                vim.lsp.buf.format({
                    bufnr = bufnr,
                    id = client.id
                })
            end,
        })
    end
end

return {
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "nvim-telescope/telescope.nvim",
            "hrsh7th/cmp-nvim-lsp",
        },
        lazy = false,
        config = function()
            local lspconfig = require("lspconfig")
            local capabilities = require("cmp_nvim_lsp").default_capabilities()
            for name, config in pairs(servers) do
                if config == true then
                    config = {}
                end

                config = vim.tbl_deep_extend("force", {}, {
                    capabilities = capabilities,
                }, config)

                lspconfig[name].setup(config)
            end

            vim.api.nvim_create_autocmd("LspAttach", { callback = attach })
        end,
    }
}
