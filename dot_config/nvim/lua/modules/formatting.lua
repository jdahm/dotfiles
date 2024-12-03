return {
  { -- Autoformat
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    keys = {
      {
        "<leader>bf",
        function()
          require("conform").format({ async = true, lsp_format = "fallback" })
        end,
        mode = "",
        desc = "[B]uffer [F]ormat",
      },
    },
    opts = {
      notify_on_error = false,
      format_on_save = false,
      format_on_save = function(bufnr)
        local enabled_filetypes = { "go", "lua" }
        local lsp_format_opt
        if enabled_filetypes[vim.bo[bufnr].filetype] ~= nil then
          lsp_format_opt = "fallback"
        else
          lsp_format_opt = "never"
        end
        return {
          timeout_ms = 500,
          lsp_format = lsp_format_opt,
        }
      end,
      formatters_by_ft = {
        lua = { "stylua" },
        -- Conform can also run multiple formatters sequentially
        -- python = { "isort", "black" },
        --
        -- You can use 'stop_after_first' to run the first available formatter from the list
        -- javascript = { "prettierd", "prettier", stop_after_first = true },
        go = { "gofmt" },
        javascript = { "prettier" },
        typescript = { "prettier" },
        javascriptreact = { "prettier" },
        typescriptreact = { "prettier" },
        css = { "prettier" },
        html = { "prettier" },
        json = { "prettier" },
        -- yaml = { "prettier" },
        markdown = { "prettier" },
        graphql = { "prettier" },
      },
    },
  },
}
