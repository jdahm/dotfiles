local M = {}

function M.plugins(use)
    -- Kitty config syntax highlighting
    use("fladson/vim-kitty")

    -- Chezmoi config syntax highlighting
    use("alker0/chezmoi.vim")

    -- Fish syntax highlighting
    use("khaveesh/vim-fish-syntax")

    -- Treesitter configurations and abstraction layer
    use({
        "nvim-treesitter/nvim-treesitter",
        run = function()
            require("nvim-treesitter.install").update({ with_sync = true })
        end,
    })

    -- Text objects for treesitter
    use("nvim-treesitter/nvim-treesitter-textobjects")

    use({
        "lewis6991/spellsitter.nvim",
        config = function()
            require("spellsitter").setup()
        end,
    })

    -- Most features required for a gopher
    use({
        "ray-x/go.nvim",
        requires = { "ray-x/guihua.lua" }, -- floating window support
        config = function()
            require("go").setup()
        end,
    })
end

function M.setup()
    -- Turn on folding in Markdown mode
    vim.g.markdown_folding = 1

    -- Avoid highlighting large files
    vim.g.large_file = 20 * 1024 * 1024

    require("nvim-treesitter.configs").setup({
        -- A list of parser names, or "all"
        -- ensure_installed = { "c", "cpp", "python", "lua", "rust", "go", "gomod", "gowork", "javascript" },
        ensure_installed = "all",

        -- Skip phpdoc
        ignore_install = { "phpdoc" },

        -- Automatically install missing parsers when entering buffer
        auto_install = true,

        -- Install parsers synchronously (only applied to `ensure_installed`)
        sync_install = false,

        highlight = {
            -- `false` will disable the whole extension
            enable = true,

            additional_vim_regex_highlighting = false,
        },

        incremental_selection = {
            enable = true,
            keymaps = {
                init_selection = "gnn",
                node_incremental = "grn",
                scope_incremental = "grc",
                node_decremental = "grm",
            },
        },

        textobjects = {
            select = {
                enable = true,

                -- Automatically jump forward to textobj, similar to targets.vim
                lookahead = true,

                keymaps = {
                    -- You can use the capture groups defined in textobjects.scm
                    ["af"] = "@function.outer",
                    ["if"] = "@function.inner",
                    ["ac"] = "@class.outer",
                    -- you can optionally set descriptions to the mappings (used in the desc parameter of nvim_buf_set_keymap
                    ["ic"] = { query = "@class.inner", desc = "Select inner part of a class region" },
                },
                -- You can choose the select mode (default is charwise 'v')
                selection_modes = {
                    ["@parameter.outer"] = "v", -- charwise
                    ["@function.outer"] = "V", -- linewise
                    ["@class.outer"] = "<c-v>", -- blockwise
                },
                -- If you set this to `true` (default is `false`) then any textobject is
                -- extended to include preceding xor succeeding whitespace. Succeeding
                -- whitespace has priority in order to act similarly to eg the built-in
                -- `ap`.
                include_surrounding_whitespace = true,
            },
            move = {
                enable = true,
                set_jumps = true, -- whether to set jumps in the jumplist
                goto_next_start = {
                    ["]m"] = "@function.outer",
                    ["]]"] = "@class.outer",
                },
                goto_next_end = {
                    ["]M"] = "@function.outer",
                    ["]["] = "@class.outer",
                },
                goto_previous_start = {
                    ["[m"] = "@function.outer",
                    ["[["] = "@class.outer",
                },
                goto_previous_end = {
                    ["[M"] = "@function.outer",
                    ["[]"] = "@class.outer",
                },
            },
        },

        rainbow = { enable = true },
    })

    -- Folds
    vim.opt.foldmethod = "expr"
    vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
    vim.opt.foldlevelstart = 99

    -- Temporarily highlight yanked text
    vim.api.nvim_create_autocmd(
        "TextYankPost",
        { command = 'lua vim.highlight.on_yank{higroup="IncSearch", timeout=150, on_visual=false}' }
    )

    -- Git commit message width
    local cm = vim.api.nvim_create_augroup("CommitMsg", { clear = true })
    vim.api.nvim_create_autocmd("FileType", {
        pattern = "gitcommit",
        command = "setlocal spell textwidth=72",
        group = cm,
    })

    -- Trim trailing whitespace
    local ws = vim.api.nvim_create_augroup("TrimWhitespace", { clear = true })
    vim.api.nvim_create_autocmd("BufWritePre", { command = "%s/\\s\\+$//e", group = ws })

    -- Open folds by default
    -- This is superseded by setting vim.opt.foldlevelstart=99
    -- vim.api.nvim_create_autocmd("BufEnter", { pattern = "*", command = "normal zR" })
end

return M
