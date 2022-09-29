local M = {}

function M.plugins(use)
    -- Improves built-in text objects and adds a few more
    use("wellle/targets.vim")

    -- Defines 'ae' object for entire buffer
    use({ "kana/vim-textobj-entire", requires = { "kana/vim-textobj-user" } })

    -- Improve sentence text object
    use({ "preservim/vim-textobj-sentence", requires = { "kana/vim-textobj-user" } })

    -- Delete/change/add wrappers around text (braces, parens, quotes, etc.)
    use("machakann/vim-sandwich")

    -- Operator 'cx' to exchange motions
    use("tommcdo/vim-exchange")

    -- Enable repeating supported plugin maps with '.'
    use("tpope/vim-repeat")

    -- Toggle comments
    use({
        "numToStr/Comment.nvim",
        config = function()
            require("Comment").setup()
        end,
    })

    -- Allow '*' in visual mode to search for selection
    use("thinca/vim-visualstar")

    -- Sort with 'gs'
    use("christoomey/vim-sort-motion")

    -- -- Align with gl, gL
    -- use("https://github.com/tommcdo/vim-lion")
end

function M.setup() end

return M
