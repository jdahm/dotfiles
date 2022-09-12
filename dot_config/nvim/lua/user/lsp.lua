local wk = require("which-key")
local lc = require("lspconfig")

require("mason").setup()
require("mason-lspconfig").setup({
    -- A list of servers to automatically install if they're not already installed. Example: { "rust_analyzer@nightly", "sumneko_lua" }
    -- This setting has no relation with the `automatic_installation` setting.
    ensure_installed = { "gopls", "pylsp", "rust_analyzer", "eslint", "tsserver", "terraformls", "sumneko_lua" },

    automatic_installation = true
})

vim.g.diagnostics_visible = true
function _G.toggle_diagnostics()
    if vim.g.diagnostics_visible then
        vim.g.diagnostics_visible = false
        vim.diagnostic.disable()
    else
        vim.g.diagnostics_visible = true
        vim.diagnostic.enable()
    end
end

-- Mappings
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
wk.register({ e = { "<cmd>lua vim.diagnostic.open_float()<cr>", "lsp: open float" } }, { prefix = "<leader>" })
wk.register({ d = { "<cmd>lua vim.diagnostic.goto_prev()<cr>", "lsp: prev diag" } }, { prefix = "[" })
wk.register({ d = { "<cmd>lua vim.diagnostic.goto_next()<cr>", "lsp: next diag" } }, { prefix = "]" })
wk.register(
    { t = { name = "+toggle", s = { "<cmd>lua vim.diagnostic.setloclist()<cr>", "lsp: diag setloclist" } } },
    { prefix = "<leader>" }
)

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
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
end

lc.pylsp.setup({
    on_attach = on_attach,
    cmd = { "pylsp" },
    settings = {
        configurationSources = { "black" },
        pylsp = {
            plugins = {
                black = { enabled = true },
                pycodestyle = { enabled = false },
                pyflakes = { enabled = false },
                flake8 = { enabled = true },
                mccabe = { enabled = false },
            },
        },
    },
})

lc.gopls.setup({
    on_attach = on_attach,
})

lc.sumneko_lua.setup {
    on_attach = on_attach,
    settings = {
        Lua = {
            runtime = {
                -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
                version = 'LuaJIT',
            },
            diagnostics = {
                -- Get the language server to recognize the `vim` global
                globals = { 'vim' },
            },
            workspace = {
                -- Make the server aware of Neovim runtime files
                library = vim.api.nvim_get_runtime_file("", true),
            },
            -- Do not send telemetry data containing a randomized but unique identifier
            telemetry = {
                enable = false,
            },
        },
    },
}

lc.eslint.setup({
    on_attach = on_attach,
    cmd = { "eslint" },
})

require("null-ls").setup({
    sources = {
        require("null-ls").builtins.formatting.stylua,
        require("null-ls").builtins.diagnostics.eslint,
        require("null-ls").builtins.completion.spell,
    },
    on_attach = on_attach,
})
