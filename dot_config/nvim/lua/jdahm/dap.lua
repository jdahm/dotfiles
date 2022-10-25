local M = {}

function M.plugins(use)
  use("mfussenegger/nvim-dap")
end

function M.setup()
  local wk = require("which-key")

  wk.register({ ["<F5>"] = { "<Cmd>lua require'dap'.continue()<CR>", "dap: continue" } }, nil)
  wk.register({ ["<F10>"] = { "<Cmd>lua require'dap'.step_over()<CR>", "dap: step over" } }, nil)
  wk.register({ ["<F11>"] = { "<Cmd>lua require'dap'.step_into()<CR>", "dap: step into" } }, nil)
  wk.register({ ["<F12>"] = { "<Cmd>lua require'dap'.step_out()<CR>", "dap: step out" } }, nil)

  wk.register({ b = { "<Cmd>lua require'dap'.toggle_breakpoint()<CR>", "toggle breakpoint" } }, { prefix = "<leader>" })
  wk.register({ B = { "<Cmd>lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>",
    "conditional breakpoint" } }, { prefix = "<leader>" })
  wk.register({ d = { r = { "<Cmd>lua require'dap'.repl.open()<CR>", "dap: open repl" },
    l = { "<Cmd>lua require'dap'.run_last()<CR>", "dap: run last" } } }, { prefix = "<leader>" })

  -- nnoremap <silent> <Leader>lp <Cmd>lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<CR>

  local dap = require('dap')
  dap.adapters.delve = {
    type = 'server',
    port = '${port}',
    executable = {
      command = 'dlv',
      args = { 'dap', '-l', '127.0.0.1:${port}' },
    }
  }

  -- https://github.com/go-delve/delve/blob/master/Documentation/usage/dlv_dap.md
  dap.configurations.go = {
    {
      type = "delve",
      name = "Debug",
      request = "launch",
      program = "${file}"
    },
    {
      type = "delve",
      name = "Debug test", -- configuration for debugging test files
      request = "launch",
      mode = "test",
      program = "${file}"
    },
    -- works with go.mod packages and sub packages
    {
      type = "delve",
      name = "Debug test (go.mod)",
      request = "launch",
      mode = "test",
      program = "./${relativeFileDirname}"
    }
  }
end

return M
