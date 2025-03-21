local setup = function()
    local cmp = require("cmp")
    local luasnip = require("luasnip")

    cmp.setup({
        sources = {
            { name = "nvim_lsp" },
            { name = "luasnip" },
            { name = "buffer" },
            { name = "path" },
        },

        window = {
            completion = cmp.config.window.bordered(),
            documentation = cmp.config.window.bordered(),
        },

        snippet = {
            expand = function(args)
                luasnip.lsp_expand(args.body)
            end
        },

        mapping = {
            ["<C-y>"] = cmp.mapping(function(fallback)
                if cmp.visible() and cmp.get_active_entry() then
                    if luasnip.expandable() then
                        luasnip.expand()
                    else
                        cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true })
                    end
                else
                    fallback()
                end
            end),

            ["<C-l>"] = cmp.mapping(function(fallback)
                if cmp.visible() then
                    cmp.select_next_item()
                elseif luasnip.locally_jumpable(1) then
                    luasnip.jump(1)
                else
                    fallback()
                end
            end, { "i", "s" }),

            ["<C-h>"] = cmp.mapping(function(fallback)
                if cmp.visible() then
                    cmp.select_prev_item()
                elseif luasnip.locally_jumpable(-1) then
                    luasnip.jump(-1)
                else
                    fallback()
                end
            end, { "i", "s" }),

            ["<C-u>"] = cmp.mapping.scroll_docs(-4),
            ["<C-d>"] = cmp.mapping.scroll_docs(4),
        }
    })
end

return {
    {
        "hrsh7th/nvim-cmp",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "L3MON4D3/LuaSnip",
            "saadparwaiz1/cmp_luasnip",
        },
        config = setup,
        lazy = false,
    },
}
