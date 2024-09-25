local lspcap = require("cmp_nvim_lsp").default_capabilities()
local servers = { "gopls", "jedi_language_server" }

for _, server in ipairs(servers) do
    require("lspconfig")[server].setup{
        capabilities = lspcap,
        handlers = handlers,
    }
end

-- completion

local cmp = require("cmp")
cmp.setup({
    sources = {
        { name = "nvim_lsp" },
    },

    snippet = {},

    window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
    },

    mapping = cmp.mapping.preset.insert({
        ["<CR>"] = cmp.mapping.confirm({ select = false }),
    })
})

-- keymaps

vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("UserLspConfig", {}),
    callback = function(ev)
        vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

        local opts = { buffer = ev.buf }
        vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
        vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)

        vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
        vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
        vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
        vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
    end,
})

-- borders

local border = {
    border = "rounded"
}

local handlers = {
    ["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, border),
    ["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signatureHelp, border),
}

vim.diagnostic.config({ float = { border = "rounded" }})
