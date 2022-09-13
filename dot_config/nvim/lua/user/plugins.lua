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
    vim.cmd([[packadd packer.nvim]])
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

    -- Granular project configuration
    use("tpope/vim-projectionist")

    -- Dims inactive portions of code using treesitter
    use({
        "folke/twilight.nvim",
        config = function()
            require("twilight").setup({})
        end,
    })

    -- Delete buffers and close files in Vim without closing your windows
    use("moll/vim-bbye")

    ------- Text Objects --------

    -- Defines 'ae' object for entire buffer
    use({ "kana/vim-textobj-entire", requires = { "kana/vim-textobj-user" } })

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
            require("Comment").setup({})
        end,
    })

    -- Allow '*' in visual mode to search for selection
    use("thinca/vim-visualstar")

    ------- Snippets --------

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

    ------- Filetypes --------

    -- Kitty config syntax highlighting
    use("fladson/vim-kitty")

    -- Chezmoi config syntax highlighting
    use("alker0/chezmoi.vim")

    -- Fish syntax highlighting
    use("khaveesh/vim-fish-syntax")

    -- Treesitter configurations and abstraction layer
    use({ "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" })

    -- Text objects for treesitter
    use({ "nvim-treesitter/nvim-treesitter-textobjects" })

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
    use({ "p00f/nvim-ts-rainbow" })

    ------- Wrappers --------

    -- Git wrapper
    use("tpope/vim-fugitive")

    -- GitHub extension for fugitive.vim
    use("tpope/vim-rhubarb")

    -- Helpers for UNIX
    use("tpope/vim-eunuch")

    -- Bracket mappings
    use("tpope/vim-unimpaired")

    -- Modern database interface for vim
    use("tpope/vim-dadbod")

    -- Fuzzy finder over lists
    use({
        "ibhagwan/fzf-lua",
        requires = { "kyazdani42/nvim-web-devicons" },
    })

    -- File manager invoked with :NnnExplorer
    use({ "luukvbaal/nnn.nvim" })

    ------- LSP --------
    use({ "williamboman/mason.nvim" })
    use({ "williamboman/mason-lspconfig.nvim" })
    use({ "neovim/nvim-lspconfig" })

    -- Use language server to inject LSP diagnostics, code actions, and more
    use({ "jose-elias-alvarez/null-ls.nvim", requires = "nvim-lua/plenary.nvim" })

    -- Completion
    use("hrsh7th/nvim-cmp")
    use("hrsh7th/cmp-buffer")
    use("hrsh7th/cmp-path")
    use("hrsh7th/cmp-nvim-lsp")
    use("hrsh7th/cmp-nvim-lua")
    use("hrsh7th/vim-vsnip")
    use("hrsh7th/cmp-vsnip")
    use("onsails/lspkind.nvim")

    -- Leverage the power of Vim's compiler plugins without being bound by synchronity
    use({ "radenling/vim-dispatch-neovim", requires = "tpope/vim-dispatch" })

    -- Diagnostics, references, telescope, quickfix, and location viewer
    use({
        "folke/trouble.nvim",
        requires = "kyazdani42/nvim-web-devicons",
        config = function()
            require("trouble").setup({})
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
