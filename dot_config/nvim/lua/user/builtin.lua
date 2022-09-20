local options = {
    -- disable creation of swapfiles
    swapfile = false,

    -- use system clipboard by default
    clipboard = "unnamedplus",

    -- disable mouse support so we use of the keyboard
    mouse = "",

    -- set the default shell
    shell = "fish",

    -- always show the sign column
    signcolumn = "yes",

    -- Autocomplete options
    completeopt = "menuone,noinsert,noselect",

}

for k, v in pairs(options) do
    vim.opt[k] = v
end

-- add current filepath to vim's path for :find
vim.opt.path:append(".,**")

-- Turn on folding in Markdown mode
vim.g.markdown_folding = 1

vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Insert --
-- -- Press jk fast to exit insert mode
-- vim.keymap.set("i", "jk", "<Esc>")

-- Visual --
-- Stay in indent mode
vim.keymap.set("v", "<", "<gv", opts)
vim.keymap.set("v", ">", ">gv", opts)

local wk = require("which-key")

wk.register({ h = { l = { ":noh<cr>", "disable highlight" } } }, { prefix = "<leader>" })

wk.register({ s = { ":w<cr>", "save buffer" } }, { prefix = "<leader>" })
wk.register({ q = { ":q<cr>", "quit" } }, { prefix = "<leader>" })

-- Temporarily highlight yanked text
vim.api.nvim_create_autocmd(
    "TextYankPost",
    { command = 'lua vim.highlight.on_yank{higroup="IncSearch", timeout=150, on_visual=false}' }
)

-- Git commit message width
local cm = vim.api.nvim_create_augroup("CommitMsg", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
    pattern = "gitcommit",
    command = "setlocal spell textwidth=72",
    group = cm,
})

-- Trim trailing whitespace
local ws = vim.api.nvim_create_augroup("TrimWhitespace", { clear = true })
vim.api.nvim_create_autocmd("BufWritePre", { command = "%s/\\s\\+$//e", group = ws })
