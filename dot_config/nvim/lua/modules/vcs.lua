return {
  { "tpope/vim-fugitive", lazy = false },
  -- NOTE: Here is where you install your plugins.
  { -- Adds git related signs to the gutter, as well as utilities for managing changes
    "lewis6991/gitsigns.nvim",
    opts = {
      signs = {
        add = { text = "+" },
        change = { text = "~" },
        delete = { text = "_" },
        topdelete = { text = "‾" },
        changedelete = { text = "~" },
      },
    },
  },
  { "almo7aya/openingh.nvim", lazy = false },
}
