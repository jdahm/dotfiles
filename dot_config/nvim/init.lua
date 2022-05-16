local install_path = vim.fn.stdpath "data" .. "/site/pack/packer/start/packer.nvim"

if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  vim.fn.execute("!git clone https://github.com/wbthomason/packer.nvim " .. install_path)
end

require("packer").startup(function(use)
  -- The package manager
  use "wbthomason/packer.nvim"

  -- Sensible defaults
  -- use "tpope/vim-sensible"

  -- Utilities for creating text objects
  use "kana/vim-textobj-user"

  -- Allow '*' in visual mode to search for selection
  use "thinca/vim-visualstar"

  -- Defines 'ae' object for entire buffer
  use "kana/vim-textobj-entire"

  -- Heuristically set 'shiftwidth' and 'expandtab'
  use "tpope/vim-sleuth"

  -- Git wrapper
  use "tpope/vim-fugitive"

  -- Enable repeating supported plugin maps with '.'
  use "tpope/vim-repeat"

  -- Delete/change/add wrappers around text (braces, parens, quotes, etc.)
  use "tpope/vim-surround"

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
  use { "windwp/nvim-autopairs", config = function() require('nvim-autopairs').setup{} end }

  -- Granular project configuration
  use "tpope/vim-projectionist"

  -- Modern database interface for vim
  use "tpope/vim-dadbod"

  -- Show register content with `""`
  use "gennaro-tedesco/nvim-peekup"

  -- Leverage the power of Vim's compiler plugins without being bound by synchronity
  use { "radenling/vim-dispatch-neovim", requires = { "tpope/vim-dispatch" } }

  -- Fuzzy finder over lists
  use { "nvim-telescope/telescope.nvim", requires = { "nvim-lua/plenary.nvim" } }

  -- Diagnostics, references, telescope, quickfix, and location viewer
  use { "folke/trouble.nvim", requires = { "kyazdani42/nvim-web-devicons" } }

  -- Treesitter configurations and abstraction layer
  use { "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" }

  -- Text objects based on treesitter
  use { "nvim-treesitter/nvim-treesitter-textobjects", run = ":TSUpdate" }

  -- Quickstart configurations for the Nvim LSP client
  use "neovim/nvim-lspconfig"

  -- Use language server to inject LSP diagnostics, code actions, and more
  use { "jose-elias-alvarez/null-ls.nvim", requires = "nvim-lua/plenary.nvim" }

  -- Kitty config syntax highlighting
  use "fladson/vim-kitty"

  -- Chezmoi config syntax highlighting
  use "alker0/chezmoi.vim"

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
      require("nnn").setup()
    end,
  }

  -- Pop-ups to help remember keybindings
  use {
    "folke/which-key.nvim",
    config = function()
      require("which-key").setup {}
    end,
  }

end)

local wk = require "which-key"

require("gitsigns").setup {
  on_attach = function(bufnr)
    local gs = package.loaded.gitsigns

    local function map(mode, l, r, opts)
      opts = opts or {}
      opts.buffer = bufnr
      vim.keymap.set(mode, l, r, opts)
    end

    -- Navigation
    map("n", "]c", function()
      if vim.wo.diff then
        return "]c"
      end
      vim.schedule(function()
        gs.next_hunk()
      end)
      return "<Ignore>"
    end, { expr = true })

    map("n", "[c", function()
      if vim.wo.diff then
        return "[c"
      end
      vim.schedule(function()
        gs.prev_hunk()
      end)
      return "<Ignore>"
    end, { expr = true })

    -- Actions
    map({ "n", "v" }, "<leader>hs", ":Gitsigns stage_hunk<CR>")
    map({ "n", "v" }, "<leader>hr", ":Gitsigns reset_hunk<CR>")
    map("n", "<leader>hS", gs.stage_buffer)
    map("n", "<leader>hu", gs.undo_stage_hunk)
    map("n", "<leader>hR", gs.reset_buffer)
    map("n", "<leader>hp", gs.preview_hunk)
    map("n", "<leader>hb", function()
      gs.blame_line { full = true }
    end)
    map("n", "<leader>tb", gs.toggle_current_line_blame)
    map("n", "<leader>hd", gs.diffthis)
    map("n", "<leader>hD", function()
      gs.diffthis "~"
    end)
    map("n", "<leader>td", gs.toggle_deleted)

    wk.register({
      h = {
        name = "GitSigns",
        s = { "Stage Hunk" },
        r = { "Reset Hunk" },
        S = { "Stage Buffer" },
        u = { "Undo Stage Hunk" },
        R = { "Reset Buffer" },
        p = { "Preview Hunk" },
        b = { "Git Blame" },
        d = { "Diff This" },
        d = { "Diff With Prev" },
      },
    }, { prefix = "<leader>" })

    -- text object
    map({ "o", "x" }, "ih", ":<c-u>gitsigns select_hunk<cr>")
  end,
}

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

local opts = { noremap = true, silent = true }

-- Make me learn the proper keys
vim.keymap.set("", "<up>", "<nop>")
vim.keymap.set("", "<down>", "<nop>")
vim.keymap.set("", "<left>", "<nop>")
vim.keymap.set("", "<right>", "<nop>")

vim.keymap.set("i", "jk", "<Esc>")

-- vim.keymap.set("n", "<esc>", ":nohl<CR>")
vim.keymap.set("n", "<leader>s", ":w<CR>")
vim.keymap.set("n", "<leader>q", ":q<CR>")

vim.keymap.set("n", "<C-j>", ":bprev<CR>")
vim.keymap.set("n", "<C-k>", ":bnext<CR>")

-- For terminal
vim.keymap.set("t", "<Esc>", "<C-\\><C-n>")
vim.keymap.set("t", "<C-v><Esc>", "<Esc>")

-- Numbering
-- num = vim.api.nvim_create_augroup("LineNumbering", { clear = true })

-- vim.api.nvim_create_autocmd({ "BufEnter", "FocusGained", "InsertLeave", "WinEnter" }, {
--   command = 'if &nu && mode() != "i" | set rnu   | endif',
--   group = num,
--   pattern = "*(.txt|.md|.rst)@<!",
-- })

-- vim.api.nvim_create_autocmd({ "BufLeave", "FocusLost", "InsertEnter", "WinLeave" }, {
--   command = "if &nu                  | set nornu | endif",
--   group = num,
--   pattern = "*(.txt|.md|.rst)@<!",
-- })

-- Trim trailing whitespace
local ws = vim.api.nvim_create_augroup("TrimWhitespace", { clear = true })
vim.api.nvim_create_autocmd("BufWritePre", { command = "%s/\\s\\+$//e", group = ws })

-- -- Auto format on save
-- local fs = vim.api.nvim_create_augroup("FormatOnSave", { clear = true })
-- vim.api.nvim_create_autocmd("BufWritePre", {
--   command = "lua vim.lsp.buf.formatting_sync(nil,1000)",
--   group = fs,
-- })

-- Git commit message width
local cm = vim.api.nvim_create_augroup("CommitMsg", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
  pattern = "gitcommit",
  command = "setlocal spell textwidth=72",
  group = cm,
})

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

  keymaps = {
    ["ab"] = "@block.outer",
    ["ib"] = "@block.inner"
  }
}

-- LSP
local lsp_config = require "lspconfig"

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
vim.keymap.set("n", "<leader>lo", vim.diagnostic.open_float)
vim.keymap.set("n", "<leader>tl", ":call v:lua.toggle_diagnostics()<CR>")
wk.register({ e = { "LSP diagnostic float" } }, { prefix = "<leader>" })
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev)
vim.keymap.set("n", "]d", vim.diagnostic.goto_next)
vim.keymap.set("n", "<leader>ts", vim.diagnostic.setloclist)

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(_, bufnr)
  local opts = { buffer = bufnr }

  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
  vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
  vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
  vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
  vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
  vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, opts)
  vim.keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, opts)
  vim.keymap.set("n", "<leader>wl", function()
    vim.inspect(vim.lsp.buf.list_workspace_folders())
  end, opts)
  wk.register(
    { w = { name = "LSP Workspaces" }, a = { "add folder" }, r = { "remove folder" }, l = { "list folders" } },
    { prefix = "<leader>" }
  )
  vim.keymap.set("n", "<leader>D", vim.lsp.buf.type_definition, opts)
  wk.register({ D = { "Show definition" } }, { prefix = "<leader>" })
  vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
  vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
  vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
  vim.keymap.set("n", "<leader>cf", vim.lsp.buf.formatting, opts)
  wk.register({ c = { name = "Code", a = { "action" }, f = { "format" } } }, { prefix = "<leader>" })
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

-- local fs = vim.api.nvim_create_augroup("FormatOnSave", { clear = true })
-- vim.api.nvim_create_autocmd("BufWritePre", {
--     command = "lua vim.lsp.buf.formatting_sync(nil,1000)",
--     group = fs,
-- })

require("null-ls").setup {
  sources = {
    require("null-ls").builtins.formatting.stylua,
    require("null-ls").builtins.diagnostics.eslint,
    require("null-ls").builtins.completion.spell,
  },
  on_attach = on_attach,
}

-- Trouble.nvim
require("trouble").setup {}
vim.keymap.set("n", "<leader>xx", "<cmd>Trouble<cr>")
vim.keymap.set("n", "<leader>xw", "<cmd>Trouble workspace_diagnostics<cr>")
vim.keymap.set("n", "<leader>xd", "<cmd>Trouble document_diagnostics<cr>")
vim.keymap.set("n", "<leader>xl", "<cmd>Trouble loclist<cr>")
vim.keymap.set("n", "<leader>xq", "<cmd>Trouble quickfix<cr>")
vim.keymap.set("n", "gR", "<cmd>Trouble lsp_references<cr>")

wk.register({
  x = {
    name = "Trouble",
    x = { "enter" },
    w = { "workspace diag." },
    d = { "document diag." },
    l = { "loclist" },
    q = { "quickfix" },
  },
}, { prefix = "<leader>" })

-- Telescope.nvim
local trouble = require "trouble.providers.telescope"

require("telescope").setup {
  defaults = {
    mappings = {
      i = {
        ["<C-h>"] = "which_key",
        ["<C-t>"] = trouble.open_with_trouble,
      },
      n = { ["<C-t>"] = trouble.open_with_trouble },
    },
  },
}

vim.keymap.set("n", "<leader>ff", require("telescope.builtin").find_files)
vim.keymap.set("n", "<leader>fg", require("telescope.builtin").live_grep)
vim.keymap.set("n", "<leader>fb", require("telescope.builtin").buffers)
vim.keymap.set("n", "<leader>fh", require("telescope.builtin").help_tags)

wk.register(
  { f = { name = "Telescope", f = { "Find Files" }, g = { "Grep" }, b = { "Buffers" }, h = { "Help Tags" } } },
  { prefix = "<leader>" }
)

-- Hardline
require("hardline").setup { theme = "nord" }

wk.register({
  t = {
    name = "Toggle",
    b = { "Current Line Blame" },
    s = { "Set Loc List" },
    l = { "Diagnostics" },
    d = { "Deleted Hunk" },
  },
}, { prefix = "<leader>" })

wk.register(
  {
    D = { "Declarations" },
    g = { "Definition" },
    i = { "Implementation" },
    r = { "References" },
    R = { "References (Trouble)" },
  },
  { prefix = "g" }
)

-- Theme
vim.cmd [[colorscheme nordfox]]

-- vim: ts=2 sts=2 sw=2 et
