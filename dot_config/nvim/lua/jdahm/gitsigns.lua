-- Gitsigns.nvim

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
    end
})
