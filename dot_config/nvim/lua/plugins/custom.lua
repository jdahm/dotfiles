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

  -- Automatic intendentation settings
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

  -- Lower timeout for formatting.
  {
    "stevearc/conform.nvim",
    opts = {
      timeout_ms = 500,
    },
  },
}
