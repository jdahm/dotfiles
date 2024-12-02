return {
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-treesitter/nvim-treesitter",
      { "fredrikaverpil/neotest-golang", version = "*" }, -- Installation
    },
    config = function()
      require("neotest").setup({
        adapters = {
          require("neotest-golang"), -- Registration
        },
      })
      vim.keymap.set("n", "<leader>na", function()
        require("neotest").run.attach()
      end)
      vim.keymap.set("n", "<leader>nf", function()
        require("neotest").run.run(vim.fn.expand("%"))
      end)
      vim.keymap.set("n", "<leader>nA", function()
        require("neotest").run.run(vim.uv.cwd())
      end)
      vim.keymap.set("n", "<leader>nT", function()
        require("neotest").run.run({ suite = true })
      end)
      vim.keymap.set("n", "<leader>nn", function()
        require("neotest").run.run()
      end)
      vim.keymap.set("n", "<leader>nl", function()
        require("neotest").run.run_last()
      end)
      vim.keymap.set("n", "<leader>ns", function()
        require("neotest").summary.toggle()
      end)
      vim.keymap.set("n", "<leader>no", function()
        require("neotest").output.open({ enter = true, auto_close = true })
      end)
      vim.keymap.set("n", "<leader>nO", function()
        require("neotest").output_panel.toggle()
      end)
      vim.keymap.set("n", "<leader>nt", function()
        require("neotest").run.stop()
      end)
    end,
  },
}
