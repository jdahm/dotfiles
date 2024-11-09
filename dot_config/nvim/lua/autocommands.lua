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

autocmd("CmdlineLeave", {
  group = vim.api.nvim_create_augroup("CmdLine", {}),
  callback = function()
    vim.fn.timer_start(5000, function()
      print(" ")
    end)
  end,
})
