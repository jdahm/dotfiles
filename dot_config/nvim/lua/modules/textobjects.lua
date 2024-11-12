return {
  "tommcdo/vim-exchange", -- Easy text exchange operator for Vim
  "kylechui/nvim-surround", -- Add/change/delete surrounding delimiter pairs with ease
  "numtostr/comment.nvim", -- Commenting
  { -- Text objects
    "chrisgrieser/nvim-various-textobjs",
    event = "UIEnter",
    opts = { useDefaultKeymaps = true },
  },
}
