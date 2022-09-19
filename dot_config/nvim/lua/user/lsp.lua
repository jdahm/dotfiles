require('mason').setup()
require("mason-lspconfig").setup({
  -- A list of servers to automatically install if they're not already installed. Example: { "rust_analyzer@nightly", "sumneko_lua" }
  -- This setting has no relation with the `automatic_installation` setting.
  ensure_installed = { "gopls", "pylsp", "rust_analyzer", "eslint", "tsserver", "terraformls", "sumneko_lua" },

  automatic_installation = true
})

local wk = require("which-key")

-- Mappings
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
wk.register({ e = { "<cmd>lua vim.diagnostic.open_float()<cr>", "lsp: open float" } }, { prefix = "<leader>" })
wk.register({ d = { "<cmd>lua vim.diagnostic.goto_prev()<cr>", "lsp: prev diag" } }, { prefix = "[" })
wk.register({ d = { "<cmd>lua vim.diagnostic.goto_next()<cr>", "lsp: next diag" } }, { prefix = "]" })
wk.register(
  { t = { name = "+toggle", s = { "<cmd>lua vim.diagnostic.setloclist()<cr>", "lsp: diag setloclist" } } },
  { prefix = "<leader>" }
)

local lsp_defaults = {
  flags = {
    debounce_text_changes = 150,
  },
  capabilities = require('cmp_nvim_lsp').update_capabilities(
    vim.lsp.protocol.make_client_capabilities()
  ),
  on_attach = function(client, bufnr)

    -- Enable completion triggered by <c-x><c-o>
    vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

    -- See `:help vim.lsp.*` for documentation on any of the below functions
    wk.register({ D = { "<cmd>lua vim.lsp.buf.declaration()<cr>", "lsp: buf decl" } }, { prefix = "g", buffer = bufnr })
    if client.supports_method("textDocument/definition") then
      wk.register(
        { d = { "<cmd>lua vim.lsp.buf.definition()<cr>", "lsp: buf def" } },
        { prefix = "g", buffer = bufnr }
      )
    end
    if client.supports_method("textDocument/hover") then
      wk.register({ K = { "<cmd>lua vim.lsp.buf.hover()<cr>", "lsp: buf hover" } }, { buffer = bufnr })
    end
    if client.supports_method("textDocument/references") then
      wk.register(
        { R = { "<cmd>Trouble lsp_references<cr>", "trouble: lsp references" } },
        { prefix = "g", buffer = bufnr }
      )
    end
    if client.supports_method("textDocument/implementation") then
      wk.register(
        { i = { "<cmd>lua vim.lsp.buf.implementation()<cr>", "lsp: buf impl" } },
        { prefix = "g", buffer = bufnr }
      )
    end
    wk.register({ ["<C-k>"] = { "<cmd>lua vim.lsp.buf.signature_help()<cr>", "lsp: sig help" } }, { buffer = bufnr })
    wk.register({
      w = {
        a = { "<cmd>lua vim.lsp.buf.add_workspace_folder()<cr>", "lsp: add workspace fldr" },
        r = { "<cmd>lua vim.lsp.buf.remove_workspace_folder()<cr>", "lsp: remove workspace fldr" },
        l = {
          "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<cr>",
          "lsp: list workspace fldr",
        },
      },
    }, { prefix = "<leader>", buffer = bufnr })
    wk.register({ D = { "<cmd>lua vim.lsp.buf.type_definition()<cr>", "lsp: type def" } }, { buffer = bufnr })
    wk.register({
      c = {
        name = "+code",
        r = { "<cmd>lua vim.lsp.buf.rename()<cr>", "lsp: rename" },
        a = { "<cmd>lua vim.lsp.buf.code_action()<cr>", "lsp: action" },
        f = { "<cmd>lua vim.lsp.buf.formatting()<cr>", "lsp: format" },
      },
    }, { prefix = "<leader>", buffer = bufnr })
    wk.register({ r = { "<cmd>lua vim.lsp.buf.references()<cr>", "lsp: refs" } }, { prefix = "g", buffer = bufnr })
    -- vim.api.nvim_exec_autocmds('User', {pattern = 'LspAttached'})
  end
}

local lspconfig = require('lspconfig')

lspconfig.util.default_config = vim.tbl_deep_extend(
  'force',
  lspconfig.util.default_config,
  lsp_defaults
)

lspconfig.gopls.setup({})
lspconfig.pylsp.setup({})
lspconfig.rust_analyzer.setup({})
lspconfig.eslint.setup({})
lspconfig.terraformls.setup({})
lspconfig.sumneko_lua.setup({})

-- vim.api.nvim_create_autocmd('User', {
--   pattern = 'LspAttached',
--   desc = 'LSP actions',
--   callback = function()
--     local bufmap = function(mode, lhs, rhs)
--       local opts = {buffer = true}
--       vim.keymap.set(mode, lhs, rhs, opts)
--     end
--
--     local wk = require("which-key")
--
--     -- Displays hover information about the symbol under the cursor
--     bufmap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>')
--     wk.register({ K = { "<cmd>lua vim.lsp.buf.hover()<cr>", "lsp: buf hover" } }, { buffer = <amatch> })
--
--     -- Jump to the definition
--     bufmap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>')
--
--     -- Jump to declaration
--     bufmap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>')
--
--     -- Lists all the implementations for the symbol under the cursor
--     bufmap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>')
--
--     -- Jumps to the definition of the type symbol
--     bufmap('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>')
--
--     -- Lists all the references
--     bufmap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>')
--
--     -- Displays a function's signature information
--     bufmap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<cr>')
--
--     -- Renames all references to the symbol under the cursor
--     bufmap('n', '<F2>', '<cmd>lua vim.lsp.buf.rename()<cr>')
--
--     -- Selects a code action available at the current cursor position
--     bufmap('n', '<F4>', '<cmd>lua vim.lsp.buf.code_action()<cr>')
--     bufmap('x', '<F4>', '<cmd>lua vim.lsp.buf.range_code_action()<cr>')
--
--     -- Show diagnostics in a floating window
--     bufmap('n', 'gl', '<cmd>lua vim.diagnostic.open_float()<cr>')
--
--     -- Move to the previous diagnostic
--     bufmap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<cr>')
--
--     -- Move to the next diagnostic
--     bufmap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<cr>')
--   end
-- })

-- cmp
require('luasnip.loaders.from_vscode').lazy_load()

local cmp = require('cmp')
local luasnip = require('luasnip')

local select_opts = { behavior = cmp.SelectBehavior.Select }

cmp.setup({
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end
  },
  sources = {
    { name = 'path' },
    { name = 'nvim_lsp', keyword_length = 3 },
    { name = 'buffer', keyword_length = 5 },
    { name = 'luasnip', keyword_length = 2 },
  },
  window = {
    documentation = cmp.config.window.bordered()
  },
  formatting = {
    fields = { 'menu', 'abbr', 'kind' },
    format = function(entry, item)
      local menu_icon = {
        nvim_lsp = 'λ',
        luasnip = '⋗',
        buffer = 'Ω',
        path = '🖫',
      }

      item.menu = menu_icon[entry.source.name]
      return item
    end,
  },
  mapping = {
    ['<Up>'] = cmp.mapping.select_prev_item(select_opts),
    ['<Down>'] = cmp.mapping.select_next_item(select_opts),

    ['<C-p>'] = cmp.mapping.select_prev_item(select_opts),
    ['<C-n>'] = cmp.mapping.select_next_item(select_opts),

    ['<C-u>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),

    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),

    ['<C-d>'] = cmp.mapping(function(fallback)
      if luasnip.jumpable(1) then
        luasnip.jump(1)
      else
        fallback()
      end
    end, { 'i', 's' }),

    ['<C-b>'] = cmp.mapping(function(fallback)
      if luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),

    ['<Tab>'] = cmp.mapping(function(fallback)
      local col = vim.fn.col('.') - 1

      if cmp.visible() then
        cmp.select_next_item(select_opts)
      elseif col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
        fallback()
      else
        cmp.complete()
      end
    end, { 'i', 's' }),

    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item(select_opts)
      else
        fallback()
      end
    end, { 'i', 's' }),
  },
})

-- require("null-ls").setup({
--     sources = {
--         require("null-ls").builtins.formatting.stylua,
--         require("null-ls").builtins.diagnostics.eslint,
--         require("null-ls").builtins.completion.spell,
--     },
--     on_attach = on_attach,
-- })
