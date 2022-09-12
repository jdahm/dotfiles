local wk = require("which-key")

-- fzf-lua
wk.register({
    f = {
        name = "+fzf",
        f = { "<cmd>lua require('fzf-lua').files()<cr>", "find files" },
        g = { "<cmd>lua require('fzf-lua').live_grep()<cr>", "live grep" },
        b = { "<cmd>lua require('fzf-lua').buffers()<cr>", "buffers" },
        q = { "<cmd>lua require('fzf-lua').quickfix()<cr>", "quickfix" },
        v = { "<cmd>lua require('fzf-lua').git_files()<cr>", "git files" },
        l = { "<cmd>lua require('fzf-lua').lines()<cr>", "lines" },
    },
}, { prefix = "<leader>" })

-- Toggling
wk.register({
    t = {
        name = "+toggle",
        i = { ":IndentBlanklineToggle<cr>", "indent guides" },
    },
}, { prefix = "<leader>" })

-- Closing buffers
wk.register(
    { b = { name = "+buffers", d = { ":Bdelete<cr>", "delete" }, w = { ":Bwipeout<cr>", "wipeout" } } },
    { prefix = "<leader>" }
)
