-- colors

vim.cmd.colorscheme("moonfly")

-- borders

local border = {
    border = "rounded"
}

local handlers = {
    ["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, border),
    ["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signatureHelp, border),
}

vim.diagnostic.config({ float = border })
