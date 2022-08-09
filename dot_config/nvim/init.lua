local install_path = vim.fn.stdpath "data" .. "/site/pack/packer/start/packer.nvim"

if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  vim.fn.execute("!git clone https://github.com/wbthomason/packer.nvim " .. install_path)
end

require("packer").startup(function(use)
  -- The package manager
  use "wbthomason/packer.nvim"

  -- Editor config
  use "editorconfig/editorconfig-vim"

  -- Intelligently reopen files at your last edit position
  use "farmergreg/vim-lastplace"

  -- Scratch buffers
  use "idbrii/itchy.vim"

  -- Allow '*' in visual mode to search for selection
  use "thinca/vim-visualstar"

  -- Defines 'ae' object for entire buffer
  use { "kana/vim-textobj-entire", requires = { "kana/vim-textobj-user" } }

  -- Search for, substitute, and abbreviate multiple variants of a word
  use "tpope/vim-abolish"

  -- Heuristically set 'shiftwidth' and 'expandtab'
  use "tpope/vim-sleuth"

  -- Git wrapper
  use "tpope/vim-fugitive"

  -- GitHub extension for fugitive.vim
  use "tpope/vim-rhubarb"

  -- Enable repeating supported plugin maps with '.'
  use "tpope/vim-repeat"

  -- Delete/change/add wrappers around text (braces, parens, quotes, etc.)
  use "machakann/vim-sandwich"

  -- Bracket mappings
  use "tpope/vim-unimpaired"

  -- Operator 'cx' to exchange motions
  use "tommcdo/vim-exchange"

  -- Toggle comments
  use {
    "numToStr/Comment.nvim",
    config = function()
      require("Comment").setup {}
    end,
  }

  -- Insert block endings
  use "tpope/vim-endwise"

  -- Automatically insert the closing brace, etc.
  use {
    "windwp/nvim-autopairs",
    config = function()
      require("nvim-autopairs").setup {}
    end,
  }

  -- Granular project configuration
  use "tpope/vim-projectionist"

  -- Modern database interface for vim
  use "tpope/vim-dadbod"

  -- Leverage the power of Vim's compiler plugins without being bound by synchronity
  use { "radenling/vim-dispatch-neovim", requires = "tpope/vim-dispatch" }

  -- Fuzzy finder over lists
  use { "junegunn/fzf", run = "./install --bin" }

  use {
    "ibhagwan/fzf-lua",
    -- optional for icon support
    requires = { "kyazdani42/nvim-web-devicons" },
  }

  -- Diagnostics, references, telescope, quickfix, and location viewer
  use {
    "folke/trouble.nvim",
    requires = "kyazdani42/nvim-web-devicons",
    config = function()
      require("trouble").setup {}
    end,
  }

  -- Treesitter configurations and abstraction layer
  use { "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" }

  -- Quickstart configurations for the Nvim LSP client
  use "neovim/nvim-lspconfig"

  -- Use language server to inject LSP diagnostics, code actions, and more
  use { "jose-elias-alvarez/null-ls.nvim", requires = "nvim-lua/plenary.nvim" }

  -- Kitty config syntax highlighting
  use "fladson/vim-kitty"

  -- Chezmoi config syntax highlighting
  use "alker0/chezmoi.vim"

  -- Fish syntax highlighting
  use "khaveesh/vim-fish-syntax"

  -- Statusline
  use "ojroques/nvim-hardline"

  -- Git indicators
  use "lewis6991/gitsigns.nvim"

  -- Colorscheme
  use "EdenEast/nightfox.nvim"

  -- File manager invoked with :NnnExplorer
  use {
    "luukvbaal/nnn.nvim",
    config = function()
      require("nnn").setup {}
    end,
  }

  -- Helpers for UNIX
  use "tpope/vim-eunuch"

  -- Pop-ups to help remember keybindings
  use {
    "folke/which-key.nvim",
    config = function()
      require("which-key").setup {}
    end,
  }
end)

local wk = require "which-key"

vim.opt.swapfile = false
vim.opt.mouse = ""
vim.opt.clipboard = "unnamedplus"

vim.opt.wildmode = "longest:full,full"

vim.keymap.set({ "n", "v" }, "<space>", "<nop>", { silent = true })
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- add current filepath to vim's path for :find
vim.opt.path = vim.opt.path + ".,**"

-- vim.opt.shell = "fish"

-- Make me learn the proper keys
vim.keymap.set("", "<up>", "<nop>")
vim.keymap.set("", "<down>", "<nop>")
vim.keymap.set("", "<left>", "<nop>")
vim.keymap.set("", "<right>", "<nop>")

vim.keymap.set("i", "jk", "<Esc>")

wk.register({ h = { l = { ":noh<cr>", "disable highlight" } } }, { prefix = "<leader>" })

wk.register({ s = { ":w<cr>", "save buffer" } }, { prefix = "<leader>" })
wk.register({ q = { ":q<cr>", "quit" } }, { prefix = "<leader>" })

-- -- For terminal
-- vim.keymap.set("t", "<Esc>", "<C-\\><C-n>")
-- vim.keymap.set("t", "<C-v><Esc>", "<Esc>")

-- Telescope.nvim
-- local trouble = require "trouble.providers.telescope"
-- require("telescope").setup {
--   defaults = {
--     mappings = {
--       i = {
--         ["<C-h>"] = "which_key",
--         ["<C-t>"] = trouble.open_with_trouble,
--       },
--       n = { ["<C-t>"] = trouble.open_with_trouble },
--     },
--   },
-- }
--
-- wk.register({
--   f = {
--     name = "+telescope",
--     f = { "<cmd>Telescope find_files<cr>", "find files" },
--     g = { "<cmd>Telescope live_grep<cr>", "live grep" },
--     b = { "<cmd>Telescope buffers<cr>", "buffers" },
--     h = { "<cmd>Telescope help_tags<cr>", "help tags" },
--   },
-- }, { prefix = "<leader>" })

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

-- Trouble.nvim
wk.register({
  x = {
    name = "+trouble",
    x = { "<cmd>Trouble<cr>", "start" },
    w = { "<cmd>Trouble workspace_diagnostics<cr>", "workspace diag" },
    d = { "<cmd>Trouble document_diagnostics<cr>", "doc diag" },
    l = { "<cmd>Trouble loclist<cr>", "loclist" },
    q = { "<cmd>Trouble quickfix<cr>", "quickfix" },
  },
}, { prefix = "<leader>" })

-- Treesitter
require("nvim-treesitter.configs").setup {
  -- A list of parser names, or "all"
  ensure_installed = { "c", "cpp", "python", "lua", "rust", "go", "gomod", "gowork", "javascript" },

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
}

-- Delete fugitive buffers
vim.api.nvim_create_autocmd("BufReadPost", {
  pattern = "fugitive://*",
  command = "set bufhidden=delete",
})

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

-- -- Auto format on save
-- local fs = vim.api.nvim_create_augroup("FormatOnSave", { clear = true })
-- vim.api.nvim_create_autocmd("BufWritePre", {
--   command = "lua vim.lsp.buf.formatting_sync(nil,1000)",
--   group = fs,
-- })

-- Gitsigns.nvim
require("gitsigns").setup {
  on_attach = function(bufnr)
    -- local gs = package.loaded.gitsigns

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
}

-- LSP
-- local lsp_config = require "lspconfig"

vim.g.diagnostics_visible = true
function _G.toggle_diagnostics()
  if vim.g.diagnostics_visible then
    vim.g.diagnostics_visible = false
    vim.diagnostic.disable()
  else
    vim.g.diagnostics_visible = true
    vim.diagnostic.enable()
  end
end

-- Mappings
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
wk.register({ e = { "<cmd>lua vim.diagnostic.open_float()<cr>", "lsp: open float" } }, { prefix = "<leader>" })
wk.register({ d = { "<cmd>lua vim.diagnostic.goto_prev()<cr>", "lsp: prev diag" } }, { prefix = "[" })
wk.register({ d = { "<cmd>lua vim.diagnostic.goto_next()<cr>", "lsp: next diag" } }, { prefix = "]" })
wk.register(
  { t = { name = "+toggle", s = { "<cmd>lua vim.diagnostic.setloclist()<cr>", "lsp: diag setloclist" } } },
  { prefix = "<leader>" }
)

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

  -- See `:help vim.lsp.*` for documentation on any of the below functions
  wk.register({ D = { "<cmd>lua vim.lsp.buf.declaration()<cr>", "lsp: buf decl" } }, { prefix = "g", buffer = bufnr })
  if client.supports_method "textDocument/definition" then
    wk.register({ d = { "<cmd>lua vim.lsp.buf.definition()<cr>", "lsp: buf def" } }, { prefix = "g", buffer = bufnr })
  end
  if client.supports_method "textDocument/hover" then
    wk.register({ K = { "<cmd>lua vim.lsp.buf.hover()<cr>", "lsp: buf hover" } }, { buffer = bufnr })
  end
  if client.supports_method "textDocument/references" then
    wk.register(
      { R = { "<cmd>Trouble lsp_references<cr>", "trouble: lsp references" } },
      { prefix = "g", buffer = bufnr }
    )
  end
  if client.supports_method "textDocument/implementation" then
    wk.register(
      { i = { "<cmd>lua vim.lsp.buf.implementation()<cr>", "lsp: buf impl" } },
      { prefix = "g", buffer = bufnr }
    )
  end
  wk.register({ ["<C-k>"] = { "<cmd>lua vim.lsp.buf.signature_help()<cr>", "lsp: sig help" } }, { buffer = bufnr })
  wk.register({
    w = {
      a = { "<cmd>lua vim.lsp.buf.add_workspace_folder()<cr>", "lsp: add workspace fldr" },
      r = { "<cmd>lua vim.lsp.buf.remove_workspace_folder()<cr>", "lsp: remove workspace fldr" },
      l = { "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<cr>", "lsp: list workspace fldr" },
    },
  }, { prefix = "<leader>", buffer = bufnr })
  wk.register({ D = { "<cmd>lua vim.lsp.buf.type_definition()<cr>", "lsp: type def" } }, { buffer = bufnr })
  wk.register({
    c = {
      name = "+code",
      r = { "<cmd>lua vim.lsp.buf.rename()<cr>", "lsp: rename" },
      a = { "<cmd>lua vim.lsp.buf.code_action()<cr>", "lsp: action" },
      f = { "<cmd>lua vim.lsp.buf.formatting()<cr>", "lsp: format" },
    },
  }, { prefix = "<leader>", buffer = bufnr })
  wk.register({ r = { "<cmd>lua vim.lsp.buf.references()<cr>", "lsp: refs" } }, { prefix = "g", buffer = bufnr })
end

-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches
require("lspconfig")["pylsp"].setup {
  on_attach = on_attach,
  cmd = { "pylsp" },
  settings = {
    configurationSources = { "black" },
    pylsp = {
      plugins = {
        black = { enabled = true },
        pycodestyle = { enabled = false },
        pyflakes = { enabled = false },
        flake8 = { enabled = true },
        mccabe = { enabled = false },
      },
    },
  },
}

require("lspconfig")["gopls"].setup {
  on_attach = on_attach,
  cmd = { "gopls" },
}

require("lspconfig")["eslint"].setup {
  on_attach = on_attach,
  cmd = { "eslint" },
}

require("lspconfig")["rls"].setup {
  on_attach = on_attach,
  cmd = { "rls" },
}

require("null-ls").setup {
  sources = {
    require("null-ls").builtins.formatting.stylua,
    require("null-ls").builtins.diagnostics.eslint,
    require("null-ls").builtins.completion.spell,
  },
  on_attach = on_attach,
}

-- Hardline
require("hardline").setup { theme = "nord" }

-- Theme
vim.cmd [[colorscheme nordfox]]

-- vim: ts=2 sts=2 sw=2 et
