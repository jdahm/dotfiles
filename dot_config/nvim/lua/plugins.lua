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

  use {'lewis6991/gitsigns.nvim'}

  use {'tpope/vim-repeat'}

  use {'tpope/vim-surround'}

  use {'tpope/vim-unimpaired'}

  use {'tpope/vim-commentary'}

  use {'tpope/vim-endwise'}

  -- use {'folke/which-key.nvim'}

  use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }

  use { 'nvim-treesitter/nvim-treesitter-textobjects', run = ':TSUpdate' }

  use {'neovim/nvim-lspconfig'}

  use {'ojroques/nvim-hardline'}

  use {'shaunsingh/nord.nvim'}

  if packer_bootstrap then
    require('packer').sync()
  end
end)
