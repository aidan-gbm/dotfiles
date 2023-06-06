local lsp = require("lsp-zero").preset({})

-- https://github.com/williamboman/mason-lspconfig.nvim#available-lsp-servers
servers = {
    "bashls",
    "cssls",
    "html",
    "dockerls",
    "gopls",
    "jedi_language_server",
    "jsonls",
    "marksman",
    "tsserver",
}

lsp.ensure_installed(servers)
lsp.setup_servers(servers)

lsp.on_attach(function(client, bufnr)
  lsp.default_keymaps({buffer = bufnr})
end)

lsp.setup()

local cmp = require("cmp")
local cmp_action = require("lsp-zero").cmp_action()

cmp.setup({
    -- https://github.com/hrsh7th/nvim-cmp/wiki/Menu-Appearance
    window = {
        completion = {
            border = "rounded"
        },
        documentation = {
            winhighlight = "Normal:Pmenu",
            border = "none",
        },
	},
	-- https://github.com/VonHeikemen/lsp-zero.nvim#keybindings-1
	mapping = {
		-- `Enter` key to confirm completion
		['<CR>'] = cmp.mapping.confirm({select = true}),

		-- Ctrl+Space to trigger completion menu
		['<C-Space>'] = cmp.mapping.complete(),

		-- Navigate between snippet placeholder
		['<Tab>'] = cmp_action.luasnip_jump_forward(),
		['<S-Tab>'] = cmp_action.luasnip_jump_backward(),
	}
})
