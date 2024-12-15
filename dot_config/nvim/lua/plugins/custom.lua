-- Custom plugin settings.

return {
  -- Set indentation settings automatically
  "tpope/vim-sleuth",

  -- -- Disable the ghost text.
  {
    "hrsh7th/nvim-cmp",
    opts = {
      experimental = {
        ghost_text = false,
      },
    },
  },

  -- Update diagnostics on insert.
  {
    "neovim/nvim-lspconfig",
    opts = {
      diagnostics = {
        update_in_insert = true,
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

  -- -- Do not auto-trigger completions from copilot.
  -- -- Instead, use the M[ and M] keybindings for prev/next completion.
  -- {
  --   "zbirenbaum/copilot.lua",
  --   opts = {
  --     suggestion = {
  --       auto_trigger = false,
  --     },
  --   },
  -- },

  -- Disable the <CR> mapping for nvim-cmp.
  {
    "hrsh7th/nvim-cmp",
    opts = function(_, opts)
      opts.mapping["<CR>"] = nil
    end,
  },

  -- Add toggles for Copilot and all autocompletion.
  {
    "hrsh7th/nvim-cmp",
    opts = function(_, opts)
      -- opts.auto_brackets = { "go" }
      -- opts.completion.autocomplete = false
      local Snacks = require("snacks")
      local copilot_exists = pcall(require, "copilot")

      vim.g.your_cmp_disable_enable_toggle = true

      opts.enabled = function()
        return vim.g.your_cmp_disable_enable_toggle
      end

      -- Add a toggle for copilot within nvim-cmp.
      if copilot_exists then
        Snacks.toggle({
          name = "Copilot Completion",
          color = {
            enabled = "azure",
            disabled = "orange",
          },
          get = function()
            return not require("copilot.client").is_disabled()
          end,
          set = function(state)
            if state then
              require("copilot.command").enable()
            else
              require("copilot.command").disable()
            end
          end,
        }):map("<leader>at")
      end

      -- Add a toggle for nvim-cmp.
      Snacks.toggle({
        name = "Autocomplete",
        color = {
          enabled = "azure",
          disabled = "orange",
        },
        get = function()
          return vim.g.your_cmp_disable_enable_toggle
        end,
        set = function(state)
          if state then
            vim.g.your_cmp_disable_enable_toggle = true
          else
            vim.g.your_cmp_disable_enable_toggle = false
          end
        end,
      }):map("<leader>ac")
    end,
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
