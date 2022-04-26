local opts = { noremap = true, silent = true }
vim.api.nvim_set_keymap('', '<up>', '<nop>', opts)
vim.api.nvim_set_keymap('', '<down>', '<nop>', opts)
vim.api.nvim_set_keymap('', '<left>', '<nop>', opts)
vim.api.nvim_set_keymap('', '<right>', '<nop>', opts)

vim.api.nvim_set_keymap('i', 'jk', '<Esc>', opts)

vim.api.nvim_set_keymap('n', '<leader>c', ':nohl<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader>s', ':w<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader>q', ':q<CR>', opts)

vim.api.nvim_set_keymap('n', '<C-j>', ':bprev<CR>', opts)
vim.api.nvim_set_keymap('n', '<C-k>', ':bnext<CR>', opts)

vim.api.nvim_set_keymap('n', '<C-l>', ':nohlsearch<CR>', opts)

-- For terminal
vim.api.nvim_set_keymap('t', '<Esc>', '<C-\\><C-n>', opts)
vim.api.nvim_set_keymap('t', '<C-v><Esc>', '<Esc>', opts)

