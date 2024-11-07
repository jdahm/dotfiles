vim.keymap.set("i", "kj", "<esc>", { desc = "Remap escape in insert mode" })

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set(
  "n",
  "<F3>",
  ":set hlsearch!<CR>",
  { desc = "Toggle search highlighting" },
  { noremap = true, silent = true }
)

vim.keymap.set("n", "0", function()
  local line = vim.fn.getline(vim.fn.line(".") --[[@as string]]) --[[@as string]]
  if line:gsub("%s*", "") == "" then
    return "0"
  end
  if vim.fn.match(line, [[\S]]) == (vim.fn.col(".") - 1) then
    return "0"
  else
    return "^"
  end
end, { expr = true, desc = "Goto Beginning of text, then line" })

-- Diagnostic keymaps
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- TIP: Disable arrow keys in normal mode
vim.keymap.set("n", "<left>", '<cmd>echo "Use h to move!!"<CR>')
vim.keymap.set("n", "<right>", '<cmd>echo "Use l to move!!"<CR>')
vim.keymap.set("n", "<up>", '<cmd>echo "Use k to move!!"<CR>')
vim.keymap.set("n", "<down>", '<cmd>echo "Use j to move!!"<CR>')

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

-- Save and quit
vim.keymap.set("n", "<leader>W", ":write<CR>", { desc = "Write current buffer to disk" })
vim.keymap.set("n", "<leader>Q", ":quit<CR>", { desc = "Write current buffer to disk" })

vim.keymap.set(
  "n",
  "<leader>tw",
  ":set list!<CR>",
  { desc = "[T]oggle [w]hitespace" },
  { noremap = true, silent = true }
)

-- Buffer management
vim.keymap.set("n", "<leader>bd", ":bd<CR>", { desc = "[B]uffer delete" }, { noremap = true, silent = true })
