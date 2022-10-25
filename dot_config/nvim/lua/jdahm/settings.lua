local M = {}

function M.plugins(use)
    -- Editor config
    use("editorconfig/editorconfig-vim")

    -- Intelligently reopen files at your last edit position
    use("farmergreg/vim-lastplace")

    -- Heuristically set 'shiftwidth' and 'expandtab'
    use("tpope/vim-sleuth")

    -- Dims inactive portions of code using treesitter
    use({
        "folke/twilight.nvim",
        config = function()
            require("twilight").setup()
        end,
    })

    -- Delete buffers and close files in Vim without closing your windows
    use("famiu/bufdelete.nvim")
end

function M.setup()
    -- disable creation of swapfiles
    vim.opt.swapfile = false

    -- use system clipboard by default
    -- vim.opt.clipboard = "unnamedplus"

    -- enable the mouse, but discourage it ;-)
    vim.opt.mouse = ""

    -- add current filepath to vim's path for :find
    vim.opt.path:append(".,**")

    require("which-key").register(
        { t = { name = "+toggle", t = { ":Twilight<cr>", "twilight" } } },
        { prefix = "<leader>" }
    )

    require("which-key").register(
        { z = { ":Bdelete<cr>", "delete" } },
        { prefix = "<leader>" }
    )
end

return M
