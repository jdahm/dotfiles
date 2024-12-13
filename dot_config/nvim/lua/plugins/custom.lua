-- Custom plugin settings.

return {
  -- Set indentation settings automatically
  "tpope/vim-sleuth",

  -- Disable the ghost text.
  {
    "hrsh7th/nvim-cmp",
    opts = {
      experimental = {
        ghost_text = false,
      },
    },
  },

  -- Disable inlay hints by default. Enable with <header>uh.
  {
    "neovim/nvim-lspconfig",
    opts = {
      inlay_hints = {
        enabled = false,
      },
    },
  },

  -- Add kanawanga theme.
  "rebelot/kanagawa.nvim",

  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "tokyonight",
    },
  },
}
