local M = {}

function M.plugins(use)
    -- Easily manage multiple terminal windows
    use({
        "akinsho/toggleterm.nvim",
        tag = "*",
        config = function()
            require("toggleterm").setup()
        end,
    })
end

function M.setup()
    -- Set the default shell
    vim.opt.shell = "fish"

    require("which-key").register({
        v = {
            name = "+term",
            h = { ":ToggleTerm direction=horizontal<cr>", "horizontal" },
            v = { ":ToggleTerm direction=vertical<cr>", "vertical" },
            f = { ":ToggleTerm direction=float<cr>", "float" },
            a = { ":ToggleTermToggleAll<cr>", "all" },
        },
    }, { prefix = "<leader>" })

    local spelling_augroup = vim.api.nvim_create_augroup("Spelling", { clear = true })

    vim.api.nvim_create_autocmd("TermOpen", {
        pattern = "*", -- disable spellchecking in the embedded terminal
        command = "setlocal nospell",
        group = spelling_augroup,
    })

    local Terminal = require("toggleterm.terminal").Terminal

    local lazygit = Terminal:new({
        cmd = "lazygit",
        dir = "git_dir",
        direction = "float",
        float_opts = {
            border = "double",
        },
        -- function to run on opening the terminal
        on_open = function(term)
            vim.cmd("startinsert!")
            vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", { noremap = true, silent = true })
        end,
        -- function to run on closing the terminal
        on_close = function(term)
            vim.cmd("startinsert!")
        end,
    })

    function Lazygit_toggle()
        lazygit:toggle()
    end

    require("which-key").register({ g = { ":lua Lazygit_toggle()<cr>", "lazygit" } }, { prefix = "<leader>" })
end

return M
