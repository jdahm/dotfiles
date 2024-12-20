-- Custom plugin settings.

return {
  -- Header created from https://patorjk.com/software/taag
  {
    "snacks.nvim",
    opts = {
      dashboard = {
        preset = {
          header = [[
     ██╗ ██████╗ ██╗  ██╗ █████╗ ███╗   ██╗███╗   ██╗██████╗ 
     ██║██╔═══██╗██║  ██║██╔══██╗████╗  ██║████╗  ██║██╔══██╗
     ██║██║   ██║███████║███████║██╔██╗ ██║██╔██╗ ██║██║  ██║
██   ██║██║   ██║██╔══██║██╔══██║██║╚██╗██║██║╚██╗██║██║  ██║
╚█████╔╝╚██████╔╝██║  ██║██║  ██║██║ ╚████║██║ ╚████║██████╔╝
 ╚════╝  ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═══╝╚═╝  ╚═══╝╚═════╝ 
          ]],
        },
      },
    },
  },

  -- Set indentation settings automatically
  "tpope/vim-sleuth",

  -- Disable inlay hints by default. Enable with <header>uh.
  {
    "neovim/nvim-lspconfig",
    opts = {
      inlay_hints = {
        enabled = false,
      },
    },
  },

  -- Disable ghost text
  {
    "saghen/blink.cmp",
    opts = {
      completion = {
        documentation = {
          ghost_text = {
            enabled = false,
          },
        },
      },
    },
  },

  -- Lower timeout for formatting.
  {
    "stevearc/conform.nvim",
    opts = {
      timeout_ms = 500,
    },
  },

  -- Add kanawanga theme.
  "rebelot/kanagawa.nvim",

  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "kanagawa-wave",
    },
  },
}
