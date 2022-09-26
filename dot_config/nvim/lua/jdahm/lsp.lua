local M = {}

function M.plugins(use)
    ------- LSP --------
    use("williamboman/mason.nvim")
    use("williamboman/mason-lspconfig.nvim")
    use("neovim/nvim-lspconfig")

    -- Use language server to inject LSP diagnostics, code actions, and more
    use({ "jose-elias-alvarez/null-ls.nvim", requires = "nvim-lua/plenary.nvim" })
end

function M.setup()
    require("mason").setup({
        ui = {
            icons = {
                package_installed = "✓",
                package_pending = "➜",
                package_uninstalled = "✗",
            },
        },
    })

    local wk = require("which-key")

    -- Mappings
    -- See `:help vim.diagnostic.*` for documentation on any of the below functions
    wk.register({ e = { "<cmd>lua vim.diagnostic.open_float()<cr>", "lsp: open float" } }, { prefix = "<leader>" })
    wk.register({ d = { "<cmd>lua vim.diagnostic.goto_prev()<cr>", "lsp: prev diag" } }, { prefix = "[" })
    wk.register({ d = { "<cmd>lua vim.diagnostic.goto_next()<cr>", "lsp: next diag" } }, { prefix = "]" })
    -- NOTE: <leader>ts is currently used to set spelling, <leader>xl shows loclist in trouble.nvim
    -- wk.register(
    --     { t = { name = "+toggle", s = { "<cmd>lua vim.diagnostic.setloclist()<cr>", "lsp: diag setloclist" } } },
    --     { prefix = "<leader>" }
    -- )

    local lsp_keybindings = function(client, bufnr)
        -- Enable completion triggered by <c-x><c-o>
        vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

        -- See `:help vim.lsp.*` for documentation on any of the below functions
        wk.register(
            { D = { "<cmd>lua vim.lsp.buf.declaration()<cr>", "lsp: buf decl" } },
            { prefix = "g", buffer = bufnr }
        )
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
        wk.register(
            { ["<C-k>"] = { "<cmd>lua vim.lsp.buf.signature_help()<cr>", "lsp: sig help" } },
            { buffer = bufnr }
        )
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

    -- Map of mason to lspconfig names
    local servers = {
        ["gopls"] = "gopls",
        ["python-lsp-server"] = "pylsp",
        ["black"] = "",
        ["prettier"] = "",
        ["shfmt"] = "",
        ["isort"] = "",
        ["jq"] = "",
        ["stylua"] = "",
        ["flake8"] = "",
        ["rust_analyzer"] = "rust_analyzer",
        ["eslint"] = "eslint",
        ["typescript-language-server"] = "tsserver",
        ["terraformls"] = "terraformls",
        ["lua-language-server"] = "sumneko_lua",
    }

    require("mason-lspconfig").setup({
        ensure_installed = servers,
        automatic_installation = true,
    })

    local lspconfig = require("lspconfig")

    for _, lsp in pairs(servers) do
        if lsp ~= "" then
            local setup = {
                capabilities = require("cmp_nvim_lsp").update_capabilities(vim.lsp.protocol.make_client_capabilities()),
                on_attach = function(client, bufnr)
                    lsp_keybindings(client, bufnr)
                    if ({ pylsp = "", sumneko_lua = "" })[lsp] ~= nil then
                        client.resolved_capabilities.document_formatting = false
                        client.resolved_capabilities.document_range_formatting = false
                    end
                end,
            }
            if lsp == "pylsp" then
                setup["settings"] = {
                    pylsp = {
                        configurationSources = { "flake8" },
                        plugins = {
                            flake8 = { enabled = true },
                            mypy = { enabled = false },
                            isort = { enabled = false },
                            yapf = { enabled = false },
                            pylint = { enabled = false },
                            pydocstyle = { enabled = false },
                            mccabe = { enabled = false },
                            preload = { enabled = false },
                            rope_completion = { enabled = false },
                            pyflakes = { enabled = false },

                            pycodestyle = { enabled = false },
                        },
                    },
                }
            elseif lsp == "sumneko_lua" then
                setup["settings"] = { Lua = { diagnostics = { globals = { "vim" } } } }
            end
            lspconfig[lsp].setup(setup)
        end
    end

    require("lspkind").init()

    -- null-ls
    local null_ls = require("null-ls")

    local formatting = null_ls.builtins.formatting
    local completion = null_ls.builtins.completion

    null_ls.setup({
        sources = {
            formatting.prettier,
            formatting.black,
            formatting.gofmt,
            formatting.shfmt,
            formatting.isort,
            formatting.stylua,
            completion.spell,
        },
    })
end

return M
