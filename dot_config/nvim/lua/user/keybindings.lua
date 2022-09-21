local wk = require("which-key")

-- Telescope
require("telescope").setup({
    defaults = {
        mappings = {
            i = {
                ["<C-h>"] = "which_key",
            },
        },
    },
})

wk.register({
    f = {
        name = "+telescope",
        f = { "<cmd>lua require('telescope.builtin').find_files({hidden=true})<cr>", "find files" },
        g = { "<cmd>lua require('telescope.builtin').live_grep()<cr>", "live grep" },
        b = { "<cmd>lua require('telescope.builtin').buffers()<cr>", "buffers" },
        q = { "<cmd>lua require('telescope.builtin').quickfix()<cr>", "quickfix" },
        h = { "<cmd>lua require('telescope.builtin').help_tags()<cr>", "help" },
        v = { "<cmd>lua require('telescope.builtin').git_files()<cr>", "git files" },
        s = { "<cmd>lua require('telescope.builtin').git_stash()<cr>", "git stashes" },
        c = { "<cmd>lua require('telescope.builtin').git_commit()<cr>", "git commits" },
        r = { "<cmd>lua require('telescope.builtin').git_branches()<cr>", "git branches" },
        o = { "<cmd>lua require('telescope.builtin').oldfiles()<cr>", "old files" },
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

