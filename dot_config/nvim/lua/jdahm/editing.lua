local M = {}

function M.plugins(use)
    -- Insert block endings
    use("tpope/vim-endwise")

    -- Automatically insert the closing brace, etc.
    use({
        "windwp/nvim-autopairs",
        config = function()
            require("nvim-autopairs").setup({})
        end,
    })

    -- Search for, substitute, and abbreviate multiple variants of a word
    use("tpope/vim-abolish")

    -- Highlight todo-related words
    use({
        "folke/todo-comments.nvim",
        requires = "nvim-lua/plenary.nvim",
        config = function()
            require("todo-comments").setup({})
        end,
    })

    -- Bracket mappings
    use("tpope/vim-unimpaired")
end

function M.setup() end

return M
