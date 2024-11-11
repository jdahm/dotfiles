return {
  {
    "tommcdo/vim-exchange", -- Easy text exchange operator for Vim
  },
  {
    "kylechui/nvim-surround", -- Add/change/delete surrounding delimiter pairs with ease
    version = "*", -- Use for stability; omit to use `main` branch for the latest features
    event = "VeryLazy",
    opts = {},
  },
  {
    "numtostr/comment.nvim", -- Commenting
    version = "*",
    opts = {},
  },
  { -- Text objects
    "chrisgrieser/nvim-various-textobjs",
    event = "UIEnter",
    opts = { useDefaultKeymaps = true },
  },
}
