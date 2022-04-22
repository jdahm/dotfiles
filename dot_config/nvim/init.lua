-- Neovim configuration
-- Requires 0.7+

vim.opt.wildmode = "longest:full,full"

vim.opt.swapfile = false
vim.opt.number = true

-- Numbering
num = vim.api.nvim_create_augroup("LineNumbering", { clear = true })

vim.api.nvim_create_autocmd({"BufEnter", "FocusGained", "InsertLeave", "WinEnter"}, {
  command = 'if &nu && mode() != "i" | set rnu   | endif',
  group = num,
})

vim.api.nvim_create_autocmd({"BufLeave", "FocusLost", "InsertEnter", "WinLeave"}, {
  command = 'if &nu                  | set nornu | endif',
  group = num,
})

-- Trim trailing whitespace
local ws = vim.api.nvim_create_augroup("TrimWhitespace", { clear = true })
vim.api.nvim_create_autocmd("BufWritePre", { command = "%s/\\s\\+$//e", group = ws })

-- vim.opt.expandtab = true
-- vim.opt.shiftwidth = 4
-- vim.opt.tabstop = 4
-- vim.opt.smartindent = true
-- vim.opt.fixeol = true

vim.g.mapleader = ','

vim.opt.path = vim.opt.path + '.,**'

vim.opt.mouse = 'a'

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
