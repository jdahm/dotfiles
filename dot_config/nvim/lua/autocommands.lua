local autocmd = vim.api.nvim_create_autocmd

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
autocmd("TextYankPost", {
  desc = "Highlight when yanking (copying) text",
  group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

local format_sync_grp = vim.api.nvim_create_augroup("GoFormat", {})
autocmd("BufWritePre", {
  pattern = "*.go",
  callback = function()
    require("go.format").gofmt()
  end,
  group = format_sync_grp,
})
