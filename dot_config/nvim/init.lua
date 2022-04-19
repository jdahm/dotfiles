-- Built-in settings
vim.opt.wildmode = "longest:full,full"

vim.opt.mouse = 'a'
vim.opt.swapfile = false
vim.opt.number = true
vim.opt.showmatch = true
vim.opt.termguicolors = true

vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.smartindent = true
vim.opt.fixeol = true

vim.g.mapleader = ','

local opts = { noremap = true, silent = true }
vim.api.nvim_set_keymap('', '<up>', '<nop>', opts)
vim.api.nvim_set_keymap('', '<down>', '<nop>', opts)
vim.api.nvim_set_keymap('', '<left>', '<nop>', opts)
vim.api.nvim_set_keymap('', '<right>', '<nop>', opts)

vim.api.nvim_set_keymap('i', 'jk', '<Esc>', opts)

vim.api.nvim_set_keymap('n', '<leader>c', ':nohl<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader>s', ':w<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader>q', ':q<CR>', opts)

vim.api.nvim_set_keymap('n', '<leader>tk', '<C-w>t<C-w>K', opts)
vim.api.nvim_set_keymap('n', '<leader>th', '<C-w>t<C-w>H', opts)

-- Plugins
local fn = vim.fn
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  packer_bootstrap = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
end

require('packer').startup(function()
  -- Packer can manage itself
  use {'wbthomason/packer.nvim'}

  use {'tpope/vim-sensible'}

  use {'kana/vim-textobj-user'}

  use {'kana/vim-textobj-entire'}

  -- use {'tpope/vim-sleuth'}

  use {'tpope/vim-fugitive'}

  use {'tpope/vim-repeat'}

  use {'tpope/vim-surround'}

  use {'tpope/vim-unimpaired'}

  use {'tpope/vim-commentary'}

  use {'tpope/vim-endwise'}

  -- use {'folke/which-key.nvim'}

  use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }

  use {'neovim/nvim-lspconfig'}

  use {'ojroques/nvim-hardline'}

  -- use {'shaunsingh/nord.nvim'}
  use {'EdenEast/nightfox.nvim'}

  if packer_bootstrap then
    require('packer').sync()
  end
end)

require('hardline').setup {}

vim.cmd("colorscheme nordfox")

require 'nvim-treesitter.configs'.setup {
  -- A list of parser names, or "all"
  ensure_installed = { 'c', 'cpp', 'python', 'lua', 'rust', 'go', 'gomod', 'gowork', 'javascript' },

  -- Install parsers synchronously (only applied to `ensure_installed`)
  sync_install = false,

  highlight = {
    -- `false` will disable the whole extension
    enable = true,

    additional_vim_regex_highlighting = false,
  },
}

local nvim_lsp = require('lspconfig')

-- Mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
vim.api.nvim_set_keymap('n', '<leader>e', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
vim.api.nvim_set_keymap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
vim.api.nvim_set_keymap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader>q', '<cmd>lua vim.diagnostic.setloclist()<CR>', opts)

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
end

-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches
local servers = { pyright = {'pyright'}, gopls = {'gopls'}, eslint = {'eslint'} }
for lsp, cmd in pairs(servers) do
  require('lspconfig')[lsp].setup {
    on_attach = on_attach,
    flags = {
      -- This will be the default in neovim 0.7+
      debounce_text_changes = 150,
    },
    cmd = cmd
  }
end


