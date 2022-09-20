require("lualine").setup({
    options = {
        theme = "nord",
        section_separators = { left = "", right = "" },
        component_separators = { left = "|", right = "|" },
    },
    sections = {
        lualine_x = { "encoding", "filetype" },
    },
})

-- Theme
vim.cmd("colorscheme nordfox")
