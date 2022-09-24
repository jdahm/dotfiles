local fn = vim.fn

-- Automatically install packer
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
    PACKER_BOOTSTRAP = fn.system({
        "git",
        "clone",
        "--depth",
        "1",
        "https://github.com/wbthomason/packer.nvim",
        install_path,
    })
    print("Installing packer close and reopen Neovim...")
    vim.cmd("packadd packer.nvim")
end

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
    return
end

-- Have packer use a popup window
packer.init({
    display = {
        open_fn = function()
            return require("packer.util").float({ border = "rounded" })
        end,
    },
})

packer.startup(function(use)
    -- The package manager
    use("wbthomason/packer.nvim")

    ------- Keybindings --------

    -- Pop-ups to help remember keybindings
    use({
        "folke/which-key.nvim",
        config = function()
            require("which-key").setup({})
        end,
    })

    use({
        "max397574/better-escape.nvim",
        config = function()
            require("better_escape").setup({
                mapping = { "jk", "jj", "hd" }, -- a table with mappings to use
            })
        end,
    })

    ------- Editor Settings --------

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
    use("moll/vim-bbye")

    -- Easily manage multiple terminal windows
    use({
        "akinsho/toggleterm.nvim",
        tag = "*",
        config = function()
            require("toggleterm").setup()
        end,
    })

    -- A file explorer tree
    use({
        "kyazdani42/nvim-tree.lua",
        requires = { "kyazdani42/nvim-web-devicons" },
        config = function()
            require("nvim-tree").setup()
        end,
    })

    -- A snazzy bufferline
    use({ "akinsho/bufferline.nvim", tag = "v2.*", requires = "kyazdani42/nvim-web-devicons" })

    ------- Text Objects --------

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

    -- Align with gl, gL
    use("https://github.com/tommcdo/vim-lion")

    ------- Editing --------

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

    -- -- Automatic list continuation and formatting
    -- use({"gaoDean/autolist.nvim", tag = "*", config = function() require('autolist').setup({}) end})

    ------- Filetypes --------

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

    ------- UI Theme --------

    -- Statusline
    use("ojroques/nvim-hardline")

    -- Git indicators
    use("lewis6991/gitsigns.nvim")

    -- Indent guides
    use("lukas-reineke/indent-blankline.nvim")

    -- Colorscheme
    use("EdenEast/nightfox.nvim")

    -- Rainbow parens
    use("p00f/nvim-ts-rainbow")

    ------- Wrappers --------

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

    -- File manager invoked with :NnnExplorer
    use("luukvbaal/nnn.nvim")

    ------- LSP --------
    use("williamboman/mason.nvim")
    use("williamboman/mason-lspconfig.nvim")
    use("neovim/nvim-lspconfig")

    -- Use language server to inject LSP diagnostics, code actions, and more
    use({ "jose-elias-alvarez/null-ls.nvim", requires = "nvim-lua/plenary.nvim" })

    -- Completion
    use("hrsh7th/nvim-cmp")
    use("hrsh7th/cmp-buffer")
    use("hrsh7th/cmp-path")
    use("hrsh7th/cmp-nvim-lsp")
    use("hrsh7th/cmp-nvim-lua")
    use({ "L3MON4D3/LuaSnip", tag = "v1.*" })
    use("onsails/lspkind.nvim")
    use("saadparwaiz1/cmp_luasnip")
    use("rafamadriz/friendly-snippets")

    -- Leverage the power of Vim's compiler plugins without being bound by synchronity
    use({ "radenling/vim-dispatch-neovim", requires = "tpope/vim-dispatch" })

    -- Diagnostics, references, telescope, quickfix, and location viewer
    use({
        "folke/trouble.nvim",
        requires = "kyazdani42/nvim-web-devicons",
        config = function()
            require("trouble").setup()
        end,
    })

    use({
        "ray-x/go.nvim",
        config = function()
            require("go").setup()
        end,
    })

    -- Automatically set up your configuration after cloning packer.nvim
    -- Put this at the end after all plugins
    if PACKER_BOOTSTRAP then
        require("packer").sync()
    end
end)

require("jdahm.builtins")
require("jdahm.treesitter")
require("jdahm.lsp")
require("jdahm.cmp")

require("hardline").setup({ theme = "nord" })

vim.cmd("colorscheme nordfox")

require("bufferline").setup({
    options = {
        show_buffer_close_icons = false,
        show_close_icon = false,
        separator_style = "slant",
        -- numbers = "ordinal",
        max_name_length = 40,
        offsets = { { filetype = "NvimTree", text = "File Explorer", text_align = "center" } },
    },
})

require("which-key").register(
    { t = { name = "+toggle", t = { ":Twilight<cr>", "twilight" } } },
    { prefix = "<leader>" }
)

require("jdahm.gitsigns")

require("which-key").register({
    v = {
        name = "+term",
        h = { ":ToggleTerm direction=horizontal<cr>", "horizontal" },
        v = { ":ToggleTerm direction=vertical<cr>", "vertical" },
        f = { ":ToggleTerm direction=float<cr>", "float" },
        a = { ":ToggleTermToggleAll<cr>", "all" },
    },
}, { prefix = "<leader>" })

require("which-key").register({
    e = {
        name = "+tree",
        t = { ":NvimTreeToggle<cr>", "toggle" },
        f = { ":NvimTreeFocus<cr>", "focus" },
        w = { ":NvimTreeFindFile<cr>", "find file" },
        c = { ":NvimTreeCollapse<cr>", "collapse" },
    },
}, { prefix = "<leader>" })

require("which-key").register({
    x = {
        name = "+trouble",
        x = { ":TroubleToggle<cr>", "toggle" },
        w = { ":TroubleToggle workspace_diagnostics<cr>", "workspace diagnostics" },
        d = { ":TroubleToggle document_diagnostics<cr>", "document diagnostics" },
        l = { ":TroubleToggle loclist<cr>", "loclist" },
        q = { ":TroubleToggle quickfix<cr>", "quickfix" },
        t = { ":TroubleTodo", "todos" },
    },
}, { prefix = "<leader>" })

-- Telescope
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

require("which-key").register(
    { b = { name = "+buffers", d = { ":Bdelete<cr>", "delete" }, w = { ":Bwipeout<cr>", "wipeout" } } },
    { prefix = "<leader>" }
)

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

local spelling_augroup = vim.api.nvim_create_augroup("Spelling", { clear = true })

vim.api.nvim_create_autocmd("TermOpen", {
    pattern = "*", -- disable spellchecking in the embedded terminal
    command = "setlocal nospell",
    group = spelling_augroup,
})
