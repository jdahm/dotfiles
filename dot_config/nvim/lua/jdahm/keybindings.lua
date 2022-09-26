local M = {}

function M.plugins(use)
    -- Pop-ups to help remember keybindings
    use({
        "folke/which-key.nvim",
        config = function()
            require("which-key").setup({})
        end,
    })

    -- Remaps Esc to the following sequences intelligently
    use({
        "max397574/better-escape.nvim",
        config = function()
            require("better_escape").setup({
                mapping = { "jk", "jj", "hd" }, -- a table with mappings to use
            })
        end,
    })
end

function M.setup()
    -- Set leader key
    vim.g.mapleader = " "
    vim.g.maplocalleader = " "

    local ok, wk = pcall(require, "which-key")
    if not ok then
        return
    end

    wk.register({ h = { l = { ":noh<cr>", "disable highlight" } } }, { prefix = "<leader>" })

    wk.register({ s = { ":w<cr>", "save buffer" } }, { prefix = "<leader>" })
    wk.register({ q = { ":q<cr>", "quit" } }, { prefix = "<leader>" })

    wk.register({
        t = {
            name = "+toggle",
            w = { ":set wrap!<cr>", "wrap" },
            l = { ":set cursorline!<cr>", "cursorline" },
            c = { ":set cursorcolumn!<cr>", "cursorcolumn" },
            n = { ":set number!<cr>", "number" },
            s = { ":set spell!<cr>", "spell" },
        },
    }, { prefix = "<leader>" })

    -- <Esc> returns to normal mode in terminal buffers
    vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", { noremap = true, silent = true })

    -- Navigate windows with alt-{hjkl}
    vim.keymap.set("n", "<A-h>", "<C-w>h", { noremap = true, silent = true })
    vim.keymap.set("n", "<A-j>", "<C-w>j", { noremap = true, silent = true })
    vim.keymap.set("n", "<A-k>", "<C-w>k", { noremap = true, silent = true })
    vim.keymap.set("n", "<A-l>", "<C-w>l", { noremap = true, silent = true })
end

return M
