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

vim.g.mapleader = ','

local function map(mode, lhs, rhs, opts)
  local options = { noremap = true, silent = true }
  if opts then
    options = vim.tbl_extend('force', options, opts)
  end
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

map('', '<up>', '<nop>')
map('', '<down>', '<nop>')
map('', '<left>', '<nop>')
map('', '<right>', '<nop>')

map('i', 'jk', '<Esc>')

map('n', '<leader>c', ':nohl<CR>')
map('n', '<leader>s', ':w<CR>')
map('n', '<leader>q', ':q<CR>')

map('n', '<leader>tk', '<C-w>t<C-w>K')
map('n', '<leader>th', '<C-w>t<C-w>H')

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

  use {'kana/vim-textobj-entire'}

  use {'tpope/vim-sleuth'}

  use {'tpope/vim-fugitive'}

  use {'tpope/vim-repeat'}

  use {'tpope/vim-surround'}

  use {'tpope/vim-unimpaired'}

  use {'tpope/vim-commentary'}

  use {'tpope/vim-endwise'}

  use {'folke/which-key.nvim'}

  use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }

  use {'ojroques/nvim-hardline'}

  use {'shaunsingh/nord.nvim'}

  if packer_bootstrap then
    require('packer').sync()
  end
end)

require('hardline').setup {}

vim.cmd[[colorscheme nord]]

require 'nvim-treesitter.configs'.setup {
  -- A list of parser names, or "all"
  ensure_installed = { "c", "cpp", "python", "lua", "rust", "go", "gomod", "gowork" },

  -- Install parsers synchronously (only applied to `ensure_installed`)
  sync_install = false,

  highlight = {
    -- `false` will disable the whole extension
    enable = true,

    additional_vim_regex_highlighting = false,
  },
}

