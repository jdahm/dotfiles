local M = {}

function M.plugins(use)
    -- Statusline
    use("ojroques/nvim-hardline")

    -- Indent guides
    use("lukas-reineke/indent-blankline.nvim")

    -- Colorscheme
    use("EdenEast/nightfox.nvim")

    -- Rainbow parens
    use("p00f/nvim-ts-rainbow")

    -- A snazzy bufferline
    use({ "akinsho/bufferline.nvim", tag = "v2.*", requires = "kyazdani42/nvim-web-devicons" })

    -- A file explorer tree
    use({
        "kyazdani42/nvim-tree.lua",
        requires = { "kyazdani42/nvim-web-devicons" },
        config = function()
            require("nvim-tree").setup({})
        end,
    })
end

function M.setup()
    -- Disable -- INSERT --, etc. messages
    vim.opt.showmode = false

    -- Enable 24-bit color
    vim.opt.termguicolors = true

    -- Skip intro message
    vim.opt.shortmess = vim.opt.shortmess + "I"

    -- I want to enable this in the future, but it currently doesn't work well
    -- vim.opt.ch = 0

    require("hardline").setup({ theme = "nord" })

    vim.cmd("colorscheme nordfox")

    require("bufferline").setup({
        options = {
            show_buffer_close_icons = false,
            show_close_icon = false,
            separator_style = "slant",
            -- numbers = "ordinal",
            max_name_length = 40,
            offsets = { { filetype = "NvimTree", text = "File Explorer", text_align = "center" } },
        },
    })

    require("which-key").register({
        e = {
            name = "+tree",
            t = { ":NvimTreeToggle<cr>", "toggle" },
            f = { ":NvimTreeFocus<cr>", "focus" },
            w = { ":NvimTreeFindFile<cr>", "find file" },
            c = { ":NvimTreeCollapse<cr>", "collapse" },
        },
    }, { prefix = "<leader>" })
end

return M
