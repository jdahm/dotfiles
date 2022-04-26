vim.opt.swapfile = false
vim.opt.mouse = "a"
vim.opt.clipboard = "unnamedplus"
-- vim.opt.number = true

vim.opt.wildmode = "longest:full,full"

vim.g.mapleader = " "

-- Add current filepath to vim's path for :find
vim.opt.path = vim.opt.path + ".,**"
