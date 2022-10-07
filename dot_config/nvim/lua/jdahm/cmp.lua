local M = {}

function M.plugins(use)
    -- Completion
    use("hrsh7th/nvim-cmp")
    use("hrsh7th/cmp-buffer")
    use("hrsh7th/cmp-path")
    use("hrsh7th/cmp-nvim-lsp")
    use("hrsh7th/cmp-nvim-lua")
    use({ "L3MON4D3/LuaSnip", tag = "v1.*" })
    use("onsails/lspkind.nvim")
    use("saadparwaiz1/cmp_luasnip")
    use("rafamadriz/friendly-snippets")
end

function M.setup()
    -- Autocomplete options
    vim.opt.completeopt = "menu,menuone,noselect"

    -- cmp
    require("luasnip.loaders.from_vscode").lazy_load()

    local cmp = require("cmp")
    local luasnip = require("luasnip")
    local lspkind = require("lspkind")

    cmp.setup({
        snippet = {
            expand = function(args)
                luasnip.lsp_expand(args.body)
            end,
        },
        -- completion = {
        --     autocomplete = false,
        --     reason = cmp.ContextReason.Auto,
        -- },
        mapping = cmp.mapping.preset.insert({
            ["<C-d>"] = cmp.mapping.scroll_docs(-4),
            ["<C-f>"] = cmp.mapping.scroll_docs(4),
            ["<C-Space>"] = cmp.mapping.complete(),
            ["<CR>"] = cmp.mapping.confirm({
                -- behavior = cmp.ConfirmBehavior.Replace,
                select = false,
            }),
            ["<Tab>"] = cmp.mapping(function(fallback)
                if cmp.visible() then
                    cmp.select_next_item()
                elseif luasnip.expand_or_jumpable() then
                    luasnip.expand_or_jump()
                else
                    fallback()
                end
            end, { "i", "s" }),
            ["<S-Tab>"] = cmp.mapping(function(fallback)
                if cmp.visible() then
                    cmp.select_prev_item()
                elseif luasnip.jumpable(-1) then
                    luasnip.jump(-1)
                else
                    fallback()
                end
            end, { "i", "s" }),
        }),
        enable = function()
            local context = require("cmp.config.context")
            return not (context.in_treesitter_capture("comment") == true or context.in_syntax_group("Comment"))
        end,
        sources = cmp.config.sources({
            { name = "path", keyword_length = 3 },
            { name = "nvim_lsp", keyword_length = 3 },
            { name = "buffer", keyword_length = 5 },
            { name = "luasnip" },
        }, { { name = "buffer" } }),
        formatting = {
            format = lspkind.cmp_format({
                mode = "symbol", -- show only symbol annotations, could be "symbol_text"
                maxwidth = 50, -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
                ellipsis_char = "...", -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)
                -- menu = {
                --     buffer = "[Buffer]",
                --     nvim_lsp = "[LSP]",
                --     luasnip = "[LuaSnip]",
                --     nvim_lua = "[Lua]",
                --     latex_symbols = "[Latex]",
                -- },
            }),
        },
    })

    -- Set configuration for specific filetype.
    cmp.setup.filetype("markdown", {
        -- Disable by removing all sources
        sources = cmp.config.sources({}, {}),
    })

    -- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
    cmp.setup.cmdline("/", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
            { name = "buffer" },
        },
    })

    -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
    cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
            { name = "path" },
        }, {
            { name = "cmdline" },
        }),
    })
end

return M
