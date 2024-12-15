-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

-- From https://github.com/LazyVim/LazyVim/discussions/141
-- Autoformat setting
local set_autoformat = function(pattern, bool_val)
  vim.api.nvim_create_autocmd({ "FileType" }, {
    pattern = pattern,
    callback = function()
      vim.b.autoformat = bool_val
    end,
  })
end

-- set_autoformat({ "cpp" }, true)
-- set_autoformat({ "fish" }, false)
-- set_autoformat({ "lua" }, false)
-- set_autoformat({ "perl" }, false)
set_autoformat({ "yaml" }, false)
