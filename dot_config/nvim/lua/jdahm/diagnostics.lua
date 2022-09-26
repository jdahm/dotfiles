local M = {}

function M.plugins(use)
    -- Leverage the power of Vim's compiler plugins without being bound by synchronity
    use({ "radenling/vim-dispatch-neovim", requires = "tpope/vim-dispatch" })

    -- Diagnostics, references, telescope, quickfix, and location viewer
    use({
        "folke/trouble.nvim",
        requires = "kyazdani42/nvim-web-devicons",
        config = function()
            require("trouble").setup()
        end,
    })
end

function M.setup()
    require("which-key").register({
        x = {
            name = "+trouble",
            x = { ":TroubleToggle<cr>", "toggle" },
            w = { ":TroubleToggle workspace_diagnostics<cr>", "workspace diagnostics" },
            d = { ":TroubleToggle document_diagnostics<cr>", "document diagnostics" },
            l = { ":TroubleToggle loclist<cr>", "loclist" },
            q = { ":TroubleToggle quickfix<cr>", "quickfix" },
            t = { ":TroubleTodo", "todos" },
        },
    }, { prefix = "<leader>" })
end

return M
