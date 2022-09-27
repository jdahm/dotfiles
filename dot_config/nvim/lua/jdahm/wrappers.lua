local M = {}

function M.plugins(use)
    -- Git indicators
    use("lewis6991/gitsigns.nvim")

    -- Git wrapper
    use("tpope/vim-fugitive")

    -- GitHub extension for fugitive.vim
    use("tpope/vim-rhubarb")

    -- Branch viewer that integrates with fugitive
    use("rbong/vim-flog")

    -- Helpers for UNIX
    use("tpope/vim-eunuch")

    -- Modern database interface for vim
    use("tpope/vim-dadbod")

    -- Fuzzy finder over lists
    use({
        "nvim-telescope/telescope.nvim",
        branch = "0.1.x",
        requires = { "nvim-lua/plenary.nvim" },
    })

    -- -- File manager invoked with :NnnExplorer
    -- use({
    --     "luukvbaal/nnn.nvim",
    --     config = function()
    --         require("nnn").setup()
    --     end,
    -- })
end

function M.setup()
    require("gitsigns").setup({
        on_attach = function(bufnr)
            local wk = require("which-key")

            -- Navigation
            wk.register(
                { c = { "&diff ? ']c' : '<cmd>Gitsigns next_hunk<cr>'", "gs: next hunk" } },
                { prefix = "[", expr = true, buffer = bufnr }
            )
            wk.register(
                { c = { "&diff ? '[c' : '<cmd>Gitsigns prev_hunk<cr>'", "gs: prev hunk" } },
                { prefix = "]", expr = true, buffer = bufnr }
            )

            wk.register({
                h = {
                    name = "+gitsigns",
                    s = { ":Gitsigns stage_hunk<cr>", "stage hunk" },
                    r = { ":Gitsigns reset_hunk<cr>", "reset hunk" },
                    S = { "<cmd>Gitsigns stage_buffer<cr>", "stage buffer" },
                    u = { "<cmd>Gitsigns undo_stage_buffer<cr>", "undo stage hunk" },
                    R = { "<cmd>Gitsigns reset_buffer<cr>", "reset buffer" },
                    p = { "<cmd>Gitsigns preview_hunk<cr>", "preview hunk" },
                    b = { "<cmd>lua require'gitsigns'.blame_line{full=true}<cr>", "git blame" },
                    d = { "<cmd>Gitsigns diffthis<cr>", "diff this" },
                    D = { "<cmd>lua require'gitsigns'.diffthis('~')<cr>", "diff with prev" },
                },
                t = {
                    name = "+toggle",
                    t = { ":call v:lua.toggle_diagnostics()<cr>", "lsp: toggle diagnostics" },
                    b = { "<cmd>Gitsigns toggle_current_line_blame<cr>", "gs: toggle line blame" },
                    d = { "<cmd>Gitsigns toggle_deleted<cr>", "gs: toggle deleted" },
                },
            }, { prefix = "<leader>" })

            -- text object
            vim.keymap.set({ "o", "x" }, "ih", ":<c-u>gitsigns select_hunk<cr>", { buffer = bufnr })
        end,
    })

    local trouble = require("trouble")
    require("telescope").setup({
        defaults = {
            mappings = {
                i = {
                    ["<C-h>"] = "which_key",
                    ["<C-t>"] = trouble.open_with_trouble,
                },
                n = { ["<C-t>"] = trouble.open_with_trouble },
            },
        },
        pickers = {
            find_files = {
                find_command = { "rg", "--files", "--hidden", "-g", "!.git" },
            },
        },
    })

    require("which-key").register({
        f = {
            name = "+telescope",
            f = { "<cmd>lua require('telescope.builtin').find_files()<cr>", "find files" },
            g = { "<cmd>lua require('telescope.builtin').live_grep()<cr>", "live grep" },
            b = { "<cmd>lua require('telescope.builtin').buffers()<cr>", "buffers" },
            q = { "<cmd>lua require('telescope.builtin').quickfix()<cr>", "quickfix" },
            h = { "<cmd>lua require('telescope.builtin').help_tags()<cr>", "help" },
            v = { "<cmd>lua require('telescope.builtin').git_files()<cr>", "git files" },
            s = { "<cmd>lua require('telescope.builtin').git_stash()<cr>", "git stashes" },
            c = { "<cmd>lua require('telescope.builtin').git_commit()<cr>", "git commits" },
            r = { "<cmd>lua require('telescope.builtin').git_branches()<cr>", "git branches" },
            o = { "<cmd>lua require('telescope.builtin').oldfiles()<cr>", "old files" },
            t = { "<cmd>TodoTelescope<cr>", "todos" },
        },
    }, { prefix = "<leader>" })

    --    local builtin = require("nnn").builtin
    --    require("nnn").setup({
    -- mappings = {
    -- 	{ "<C-t>", builtin.open_in_tab },       -- open file(s) in tab
    -- 	{ "<C-s>", builtin.open_in_split },     -- open file(s) in split
    -- 	{ "<C-v>", builtin.open_in_vsplit },    -- open file(s) in vertical split
    -- 	{ "<C-p>", builtin.open_in_preview },   -- open file in preview split keeping nnn focused
    -- 	{ "<C-y>", builtin.copy_to_clipboard }, -- copy file(s) to clipboard
    -- 	{ "<C-w>", builtin.cd_to_path },        -- cd to file directory
    -- 	{ "<C-e>", builtin.populate_cmdline },  -- populate cmdline (:) with file(s)
    -- }
    --    })

    -- require("which-key").register({
    --     n = {
    --         name = "+nnn",
    --         e = { ":NnnExplorer<cr>", "explorer" },
    --         p = { ":NnnPicker<cr>", "picker" },
    --     },
    -- }, { prefix = "<leader>" })
end

return M
