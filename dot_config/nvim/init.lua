-- Neovim configuration
-- Requires 0.7+

local install_path = vim.fn.stdpath "data" .. "/site/pack/packer/start/packer.nvim"
local opts = { noremap = true, silent = true }

if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  vim.fn.execute("!git clone https://github.com/wbthomason/packer.nvim " .. install_path)
end

require("packer").startup(function(use)
  use "wbthomason/packer.nvim"

  use "tpope/vim-sensible"

  use "thinca/vim-visualstar"

  use "kana/vim-textobj-user"

  use "kana/vim-textobj-entire"

  use "tpope/vim-sleuth"

  use "tpope/vim-fugitive"

  use "tpope/vim-repeat"

  use "tpope/vim-surround"

  use "tpope/vim-unimpaired"

  use "numToStr/Comment.nvim"

  use "tpope/vim-endwise"

  use "tpope/vim-projectionist"

  use "tpope/vim-dadbod"

  use "alker0/chezmoi.vim"

  use "gennaro-tedesco/nvim-peekup"

  use { "radenling/vim-dispatch-neovim", requires = { "tpope/vim-dispatch" } }

  use { "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" }

  use { "nvim-treesitter/nvim-treesitter-textobjects", run = ":TSUpdate" }

  use "neovim/nvim-lspconfig"

  use { "jose-elias-alvarez/null-ls.nvim", requires = "nvim-lua/plenary.nvim" }

  use "fladson/vim-kitty"

  use "ojroques/nvim-hardline"

  use "EdenEast/nightfox.nvim"

  use { "nvim-telescope/telescope.nvim", requires = { "nvim-lua/plenary.nvim" } }

  use { "folke/trouble.nvim", requires = { "kyazdani42/nvim-web-devicons" } }

  use "lewis6991/gitsigns.nvim"
end)

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

    -- Text object
    map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>")
  end,
}

vim.opt.swapfile = false
vim.opt.mouse = "a"
vim.opt.clipboard = "unnamedplus"
-- vim.opt.number = true

vim.opt.wildmode = "longest:full,full"

vim.g.mapleader = " "

-- Add current filepath to vim's path for :find
vim.opt.path = vim.opt.path + ".,**"

vim.opt.shell = "fish"

local opts = { noremap = true, silent = true }
vim.keymap.set("", "<up>", "<nop>")
vim.keymap.set("", "<down>", "<nop>")
vim.keymap.set("", "<left>", "<nop>")
vim.keymap.set("", "<right>", "<nop>")

vim.keymap.set("i", "jk", "<Esc>")

vim.keymap.set("n", "<leader>c", ":nohl<CR>")
vim.keymap.set("n", "<leader>s", ":w<CR>")
vim.keymap.set("n", "<leader>q", ":q<CR>")

vim.keymap.set("n", "<C-j>", ":bprev<CR>")
vim.keymap.set("n", "<C-k>", ":bnext<CR>")

vim.keymap.set("n", "<C-l>", ":nohlsearch<CR>")

-- For terminal
vim.keymap.set("t", "<Esc>", "<C-\\><C-n>")
vim.keymap.set("t", "<C-v><Esc>", "<Esc>")

-- Numbering
num = vim.api.nvim_create_augroup("LineNumbering", { clear = true })

vim.api.nvim_create_autocmd({ "BufEnter", "FocusGained", "InsertLeave", "WinEnter" }, {
  command = 'if &nu && mode() != "i" | set rnu   | endif',
  group = num,
  pattern = "*(.txt|.md|.rst)@<!",
})

vim.api.nvim_create_autocmd({ "BufLeave", "FocusLost", "InsertEnter", "WinLeave" }, {
  command = "if &nu                  | set nornu | endif",
  group = num,
  pattern = "*(.txt|.md|.rst)@<!",
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
}

-- LSP
local lsp_config = require "lspconfig"

-- Mappings
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float)
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev)
vim.keymap.set("n", "]d", vim.diagnostic.goto_next)
vim.keymap.set("n", "<leader>ts", vim.diagnostic.setloclist)

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  vim.api.nvim_buf_set_keymap(bufnr, "n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
  vim.api.nvim_buf_set_keymap(bufnr, "n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
  vim.api.nvim_buf_set_keymap(bufnr, "n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
  vim.api.nvim_buf_set_keymap(bufnr, "n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
  vim.api.nvim_buf_set_keymap(bufnr, "n", "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
  vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>wa", "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>", opts)
  vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>wr", "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>", opts)
  vim.api.nvim_buf_set_keymap(
    bufnr,
    "n",
    "<leader>wl",
    "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>",
    opts
  )
  vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>D", "<cmd>lua vim.lsp.buf.type_definition()<CR>", opts)
  vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
  vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)
  vim.api.nvim_buf_set_keymap(bufnr, "n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
  vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>tf", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
end

-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches
require("lspconfig")["pylsp"].setup {
  on_attach = on_attach,
  cmd = { "pylsp" },
  settings = { pylsp = { plugins = { black = { enabled = true } } } },
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

-- Telescope.nvim
require("telescope").setup {
  defaults = {
    -- Default configuration for telescope goes here:
    -- config_key = value,
    mappings = {
      i = {
        -- map actions.which_key to <C-h> (default: <C-/>)
        -- actions.which_key shows the mappings for your picker,
        -- e.g. git_{create, delete, ...}_branch for the git_branches picker
        ["<C-h>"] = "which_key",
      },
    },
  },
  pickers = {
    -- Default configuration for builtin pickers goes here:
    -- picker_name = {
    --   picker_config_key = value,
    --   ...
    -- }
    -- Now the picker_config_key will be applied every time you call this
    -- builtin picker
  },
  extensions = {
    -- Your extension configuration goes here:
    -- extension_name = {
    --   extension_config_key = value,
    -- }
    -- please take a look at the readme of the extension you want to configure
  },
}

-- Comment.nvim
require("Comment").setup()

vim.keymap.set("n", "<leader>ff", require("telescope.builtin").find_files)
vim.keymap.set("n", "<leader>fg", require("telescope.builtin").live_grep)
vim.keymap.set("n", "<leader>fb", require("telescope.builtin").buffers)
vim.keymap.set("n", "<leader>fh", require("telescope.builtin").help_tags)

-- Trouble.nvim
vim.api.nvim_set_keymap("n", "<leader>xx", "<cmd>Trouble<cr>", opts)
vim.api.nvim_set_keymap("n", "<leader>xw", "<cmd>Trouble workspace_diagnostics<cr>", opts)
vim.api.nvim_set_keymap("n", "<leader>xd", "<cmd>Trouble document_diagnostics<cr>", opts)
vim.api.nvim_set_keymap("n", "<leader>xl", "<cmd>Trouble loclist<cr>", opts)
vim.api.nvim_set_keymap("n", "<leader>xq", "<cmd>Trouble quickfix<cr>", opts)
vim.api.nvim_set_keymap("n", "gR", "<cmd>Trouble lsp_references<cr>", opts)
require("trouble").setup {}

-- Hardline
require("hardline").setup { theme = "nord" }

-- Theme
vim.cmd [[colorscheme nordfox]]

