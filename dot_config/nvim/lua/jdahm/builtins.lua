local ok, wk = pcall(require, "which-key")
if not ok then
    return
end

wk.register({ h = { l = { ":noh<cr>", "disable highlight" } } }, { prefix = "<leader>" })

wk.register({ s = { ":w<cr>", "save buffer" } }, { prefix = "<leader>" })
wk.register({ q = { ":q<cr>", "quit" } }, { prefix = "<leader>" })

wk.register({
    t = {
        name = "+toggle",
        w = { ":set wrap!<cr>", "wrap" },
        l = { ":set cursorline!<cr>", "cursorline" },
        c = { ":set cursorcolumn!<cr>", "cursorcolumn" },
        n = { ":set number!<cr>", "number" },
        s = { ":set spell!<cr>", "spell" },
    },
}, { prefix = "<leader>" })

-- <Esc> returns to normal mode in terminal buffers
vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", { noremap = true, silent = true })

-- {"BufReadPost,FileReadPost", "*", "normal zR"}

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

-- Open folds by default
-- This is superseded by setting vim.opt.foldlevelstart=99
-- vim.api.nvim_create_autocmd("BufEnter", { pattern = "*", command = "normal zR" })
