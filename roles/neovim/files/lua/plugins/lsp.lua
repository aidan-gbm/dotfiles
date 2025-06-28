local servers = {
    clangd = {
        filetypes = { "c", "cpp" },
    },
    gopls = true,
    ruff = {
	init_options = {
	    settings = {
		lineLength = 80,
	    }
	}
    },
    pyright = {
	settings = {
	    python = {
		analysis = {
		    useLibraryCodeForTypes = true,
		},
		typeCheckingMode = "off",
	    }
	}
    },
    terraformls = true,
}

vim.filetype.add({
    extension = {
        tf = "terraform",
    }
})

local attach = function(args)
    local client = assert(
        vim.lsp.get_client_by_id(args.data.client_id),
        "no valid client"
    )

    if client.name == "ruff" then
	client.server_capabilities.hoverProvider = false
    end

    if client.supports_method("textDocument/formatting") then
        vim.api.nvim_create_autocmd("BufWritePre", {
            buffer = args.buf,
            callback = function()
                vim.lsp.buf.format({
                    bufnr = args.buf,
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

            -- indirect
            "hrsh7th/nvim-cmp",
        },
        lazy = false,
        config = function()
            local capabilities = require("cmp_nvim_lsp").default_capabilities()
            for name, config in pairs(servers) do
                if config == true then
                    config = {}
                end

                config = vim.tbl_deep_extend("force", {}, {
                    capabilities = capabilities,
                }, config)

                vim.lsp.config(name, config)
		vim.lsp.enable(name)
            end

	    local builtin = require("telescope.builtin")
	    vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
	    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, {})
	    vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, {})

	    vim.keymap.set("n", "gd", builtin.lsp_definitions, {})
	    vim.keymap.set("n", "gr", builtin.lsp_references, {})
	    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, {})
	    vim.keymap.set("n", "gt", vim.lsp.buf.type_definition, {})
	    vim.keymap.set("n", "ga", vim.lsp.buf.code_action, {})

	    vim.api.nvim_create_autocmd("LspAttach", { callback = attach })
        end,
    }
}
