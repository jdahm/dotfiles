return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      { "williamboman/mason.nvim", config = true }, -- NOTE: Must be loaded before dependants
      "jay-babu/mason-nvim-dap.nvim",
      "leoluz/nvim-dap-go",
      "theHamsta/nvim-dap-virtual-text",
    },
    config = function()
      require("dap-go").setup()
      require("nvim-dap-virtual-text").setup({})

      vim.keymap.set("n", "<F5>", function()
        require("dap").continue()
      end)
      vim.keymap.set("n", "<F10>", function()
        require("dap").step_over()
      end)
      vim.keymap.set("n", "<F11>", function()
        require("dap").step_into()
      end)
      vim.keymap.set("n", "<F12>", function()
        require("dap").step_out()
      end)
      vim.keymap.set("n", "<Leader>db", function()
        require("dap").toggle_breakpoint()
      end)
      vim.keymap.set("n", "<Leader>dB", function()
        require("dap").set_breakpoint()
      end)
      vim.keymap.set("n", "<Leader>dL", function()
        require("dap").set_breakpoint(nil, nil, vim.fn.input("Log point message: "))
      end)
      vim.keymap.set("n", "<Leader>dr", function()
        require("dap").repl.open()
      end)
      vim.keymap.set("n", "<Leader>dl", function()
        require("dap").run_last()
      end)

      require("mason-nvim-dap").setup({
        automatic_installation = true,
        ensure_installed = { "delve", "python" },
      })
    end,
  },
}
