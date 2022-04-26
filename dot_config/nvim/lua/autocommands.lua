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
