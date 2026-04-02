local ls_config = {
    pyright = {
	cmd = { "pyright-langserver", "--stdio" },
	filetypes = { "python" },
	root_markers = {
	    "pyproject.toml",
	    "requirements.txt",
	    ".git",
	},

	-- https://github.com/microsoft/pyright/blob/main/docs/settings.md
	settings = {
	    python = {
		disableLanguageServices = false,
		analysis = {
		    autoSearchPaths = true,
		    autoImportCompletions = true,
		    useLibraryCodeForTypes = true,
		    diagnosticMode = "openFilesOnly",
		    typeCheckingMode = "strict",
		},
	    },
	},
    },
    gopls = {
	cmd = { "gopls" },
	filetypes = { "go", "gomod" },
	root_markers = {
	    "go.mod",
	    ".git",
	},
    },
    lua_ls = {
	cmd = { "lua-language-server" },
	filetypes = { "lua" },
	root_markers = { ".git" },

	-- https://luals.github.io/wiki/settings/
	settings = {
	    Lua = {},
	},

	-- make LS aware of neovim sources
	on_init = function(client)
	    client.config.settings.Lua = vim.tbl_deep_extend(
		"force", client.config.settings.Lua,
		{
		    runtime = {
			version = "LuaJIT",
			path = {
			    "lua/?.lua",
			    "lua/?/init.lua",
			},
		    },
		    workspace = {
			checkThirdParty = false,
			library = { vim.env.VIMRUNTIME },
		    },
		}
	    )
	end,
    },
}

for server, cfg in pairs(ls_config) do
    local caps = require("cmp_nvim_lsp").default_capabilities()
    cfg = vim.tbl_deep_extend("force", {}, {
	capabilities = caps,
    }, cfg)

    vim.lsp.config(server, cfg)
    vim.lsp.enable(server)
end

vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(ev)
	local client = assert(
	    vim.lsp.get_client_by_id(ev.data.client_id),
	    "no valid client"
	)

	if client.name == "pyright" then
	    -- TODO: manual black formatting

	elseif client.supports_method(client, "textDocument/formatting", ev.buf) then
	    vim.api.nvim_create_autocmd("BufWritePre", {
		buffer = ev.buf,
		callback = function()
		    vim.lsp.buf.format({
			bufnr = ev.buf,
			id = client.id,
		    })
		end,
	    })
	end
    end
})

vim.diagnostic.config({
    severity_sort = true,
    virtual_text = true,
    underline = false,
    signs = {
	numhl = {
	    [vim.diagnostic.severity.ERROR] = "ErrorMsg",
	    [vim.diagnostic.severity.WARN] = "WarningMsg"
	}
    },
})

-- basic keymaps, additional mappings w/ telescope
vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, {})
vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, {})

-- completion
local cmp = require("cmp")

cmp.setup({
    sources = {
        { name = "nvim_lsp" },
        { name = "buffer" },
        { name = "path" },
    },

    window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
    },

    formatting = {
        format = function(entry, vim_item)
            vim_item.menu = ({
                nvim_lsp = "[LSP]",
                buffer = "[BUF]",
                path = "[FS]",
            })[entry.source.name]
            return vim_item
        end
    },

    mapping = cmp.mapping.preset.insert({
        ["<C-y>"] = cmp.mapping(function(fallback)
	   if cmp.visible() then
	       cmp.confirm({ select = true })
	   else
	       fallback()
	   end
       end),
       ["<C-u>"] = cmp.mapping.scroll_docs(-4),
       ["<C-d>"] = cmp.mapping.scroll_docs(4),
       ["<C-Space>"] = cmp.mapping.complete(),
    })
})

