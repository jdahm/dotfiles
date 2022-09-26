-- @jdahm's neovim config

local M = {}

-- Prefix each string entry in the array with 'prefix'
local function prefix_entries(prefix, t)
    for i = 1, #t do
        t[i] = prefix .. t[i]
    end

    return t
end

M.modules = prefix_entries("jdahm.", {
    "keybindings",
    "settings",
    "terminal",
    "look",
    "textobj",
    "editing",
    "filetypes",
    "wrappers",
    "lsp",
    "diagnostics",
    "cmp",
})

-- disable some plugins that are distributed with vim
local function disable_builtin_plugins()
    -- Disable netrw
    vim.g.loaded = 1
    vim.g.loaded_netrwPlugin = 1
end

function M.setup()
    disable_builtin_plugins()

    -- Setup the modules with the plugin framework
    require("jdahm.plugins").setup({ modules = M.modules })

    -- Call the setup code for each module
    for _, m in pairs(M.modules) do
        require(m).setup()
    end
end

return M
