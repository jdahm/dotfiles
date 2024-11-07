local all_modules = {}
local function add_module(name)
  local m = require("modules." .. name)
  for _, v in ipairs(m) do
    table.insert(all_modules, v)
  end
end

add_module("textobjects")
add_module("treesitter")
add_module("tpope")
add_module("vcs")
add_module("lsp")
add_module("ui")
add_module("completion")
add_module("formatting")
add_module("linting")
add_module("languages")
add_module("editor")

return all_modules
