-- @jdahm's neovim config

local options = {
    -- disable creation of swapfiles
    swapfile = false,

    -- use system clipboard by default
    clipboard = "unnamedplus",

    -- enable the mouse, but discourage it ;-)
    mouse = "a",

    -- set the default shell
    shell = "fish",

    -- Autocomplete options
    completeopt = "menu,menuone,noselect",

    -- Disable -- INSERT --, etc. messages
    showmode = false,

    -- Enable 24-bit color
    termguicolors = true,

    -- Skip intro message
    shortmess = vim.opt.shortmess + "I"
}

for k, v in pairs(options) do
    vim.opt[k] = v
end

-- add current filepath to vim's path for :find
vim.opt.path:append(".,**")

-- Turn on folding in Markdown mode
vim.g.markdown_folding = 1

-- Avoid highlighting large files
vim.g.large_file = 20 * 1024 * 1024

-- Set leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Disable netrw
vim.g.loaded = 1
vim.g.loaded_netrwPlugin = 1

require("jdahm")
