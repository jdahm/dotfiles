return {
  { -- Autocompletion
    "hrsh7th/nvim-cmp",
    lazy = false,
    dependencies = {
      -- Snippet Engine & its associated nvim-cmp source
      {
        "L3MON4D3/LuaSnip",
        build = "make install_jsregexp",
      },
      "saadparwaiz1/cmp_luasnip",

      -- Adds other completion capabilities.
      --  nvim-cmp does not ship with all sources by default. They are split
      --  into multiple repos for maintenance purposes.
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-path",
      "petertriho/cmp-git",
      -- "windwp/nvim-autopairs",
      {
        "zbirenbaum/copilot.lua",
        cmd = "Copilot",
        event = "InsertEnter",
        config = function()
          require("copilot").setup({
            suggestion = { enabled = false },
            panel = { enabled = false },
          })
        end,
      },
      {
        "zbirenbaum/copilot-cmp",
        opts = {},
      },
    },
    config = function()
      -- See `:help cmp`
      local cmp = require("cmp")
      local luasnip = require("luasnip")
      luasnip.config.setup({})

      local function toggle_autocomplete()
        local current_setting = cmp.get_config().completion.autocomplete
        if current_setting and #current_setting > 0 then
          cmp.setup({ completion = { autocomplete = false } })
          vim.notify("Autocomplete disabled")
        else
          cmp.setup({ completion = { autocomplete = { cmp.TriggerEvent.TextChanged } } })
          vim.notify("Autocomplete enabled")
        end
      end

      vim.api.nvim_create_user_command("CmpToggle", toggle_autocomplete, {})
      vim.api.nvim_set_keymap(
        "n",
        "<leader>tc",
        ":CmpToggle<CR>",
        { noremap = true, silent = true, desc = "[T]oggle [C]ompletion" }
      )

      local function toggle_copilot()
        local sources = cmp.get_config().sources
        for i = 1, #sources do
          if sources[i].name == "copilot" then
            table.remove(sources, i)
            cmp.setup.buffer({ sources = sources })
            vim.notify("GitHub Copilot disabled")
            return
          end
        end
        table.insert(sources, { name = "copilot" })
        cmp.setup.buffer({ sources = sources })
        vim.notify("GitHub Copilot enabled")
      end

      vim.api.nvim_create_user_command("CmpToggleCopilot", toggle_copilot, {})
      vim.api.nvim_set_keymap(
        "n",
        "<leader>tg",
        ":CmpToggleCopilot<CR>",
        { noremap = true, silent = true, desc = "[T]oggle [G]itHub Copilot" }
      )

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        -- Disable autocomplete and use custom function below with delay.
        completion = { autocomplete = false, completeopt = "menu,menuone,noinsert" },

        -- For an understanding of why these mappings were
        -- chosen, you will need to read `:help ins-completion`
        --
        -- No, but seriously. Please read `:help ins-completion`, it is really good!
        mapping = cmp.mapping.preset.insert({
          -- Select the [n]ext item
          ["<C-n>"] = cmp.mapping.select_next_item(),
          -- Select the [p]revious item
          ["<C-p>"] = cmp.mapping.select_prev_item(),

          -- Scroll the documentation window [b]ack / [f]orward
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),

          -- Accept ([y]es) the completion.
          --  This will auto-import if your LSP supports it.
          --  This will expand snippets if the LSP sent a snippet.
          ["<C-y>"] = cmp.mapping.confirm({ select = true }),

          -- If you prefer more traditional completion keymaps,
          -- you can uncomment the following lines
          --['<CR>'] = cmp.mapping.confirm { select = true },
          --['<Tab>'] = cmp.mapping.select_next_item(),
          --['<S-Tab>'] = cmp.mapping.select_prev_item(),

          -- Manually trigger a completion from nvim-cmp.
          --  Generally you don't need this, because nvim-cmp will display
          --  completions whenever it has completion options available.
          ["<C-Space>"] = cmp.mapping.complete({}),

          -- Think of <c-l> as moving to the right of your snippet expansion.
          --  So if you have a snippet that's like:
          --  function $name($args)
          --    $body
          --  end
          --
          -- <c-l> will move you to the right of each of the expansion locations.
          -- <c-h> is similar, except moving you backwards.
          ["<C-l>"] = cmp.mapping(function()
            if luasnip.expand_or_locally_jumpable() then
              luasnip.expand_or_jump()
            end
          end, { "i", "s" }),
          ["<C-h>"] = cmp.mapping(function()
            if luasnip.locally_jumpable(-1) then
              luasnip.jump(-1)
            end
          end, { "i", "s" }),

          -- For more advanced Luasnip keymaps (e.g. selecting choice nodes, expansion) see:
          --    https://github.com/L3MON4D3/LuaSnip?tab=readme-ov-file#keymaps
        }),
        sources = {
          { name = "copilot" },
          { name = "nvim_lsp" },
          { name = "path" },
          { name = "luasnip" },
          { name = "git" },
        },
      })

      local cmp_autopairs = require("nvim-autopairs.completion.cmp")
      cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())

      local completionDelay = 750
      local timer = nil

      function _G.setAutoCompleteDelay(delay)
        completionDelay = delay
      end

      function _G.getAutoCompleteDelay()
        return completionDelay
      end

      vim.api.nvim_create_autocmd({ "TextChangedI", "CmdlineChanged" }, {
        pattern = "*",
        callback = function()
          local line = vim.api.nvim_get_current_line()
          local cursor = vim.api.nvim_win_get_cursor(0)[2]

          local current = string.sub(line, cursor, cursor + 1)
          if current == "." or current == "," or current == " " then
            require("cmp").close()
          end

          if timer then
            vim.loop.timer_stop(timer)
            timer = nil
          end

          timer = vim.loop.new_timer()
          timer:start(
            _G.getAutoCompleteDelay(),
            0,
            vim.schedule_wrap(function()
              cmp.complete({ reason = cmp.ContextReason.Auto })
            end)
          )
        end,
      })
    end,
  },
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = true,
  },
  {
    "windwp/nvim-ts-autotag",
    lazy = false,
    opts = {
      opts = {
        -- Defaults
        enable_close = true, -- Auto close tags
        enable_rename = true, -- Auto rename pairs of tags
        enable_close_on_slash = false, -- Auto close on trailing </
      },
    },
  },
}
