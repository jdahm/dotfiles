-- Neovim configuration
-- Requires 0.7+

vim.opt.wildmode = "longest:full,full"

vim.opt.swapfile = false
vim.opt.number = true

-- vim.opt.expandtab = true
-- vim.opt.shiftwidth = 4
-- vim.opt.tabstop = 4
-- vim.opt.smartindent = true
-- vim.opt.fixeol = true

vim.g.mapleader = ','

vim.opt.path = vim.opt.path + '.,**'

local opts = { noremap = true, silent = true }
vim.api.nvim_set_keymap('', '<up>', '<nop>', opts)
vim.api.nvim_set_keymap('', '<down>', '<nop>', opts)
vim.api.nvim_set_keymap('', '<left>', '<nop>', opts)
vim.api.nvim_set_keymap('', '<right>', '<nop>', opts)

vim.api.nvim_set_keymap('i', 'jk', '<Esc>', opts)

vim.api.nvim_set_keymap('n', '<leader>c', ':nohl<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader>s', ':w<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader>q', ':q<CR>', opts)

-- Load modules
for _, module in ipairs({'plugins', 'look', 'treesitter', 'lsp'}) do
    require(module)
end
