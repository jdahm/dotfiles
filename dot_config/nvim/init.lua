-- Sources:
-- * https://github.com/max397574/omega-nvim
-- * https://www.josean.com/posts/neovim-linting-and-formatting

--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used).
vim.g.mapleader = ","
vim.g.maplocalleader = ","

-- [[ Install `lazy.nvim` plugin manager ]]
--    See `:help lazy.nvim.txt` or https://github.com/folke/lazy.nvim for more info.
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    error("Error cloning lazy.nvim:\n" .. out)
  end
end
vim.opt.runtimepath:prepend(lazypath)

-- Setup Lazy.nvim (loads modules)
require("lazy").setup({
  spec = {
    { import = "modules" },
  },
  defaults = {
    lazy = false,
    version = false,
  },
})

-- General configuration
require("options")
require("autocommands")
require("keymappings")
