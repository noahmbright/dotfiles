-- https://github.com/VonHeikemen/nvim-starter
require "core.lazy"
local core = {}

local dependencies = {
    "core.keymaps",
    "core.statusline",
    "core.options",
    "core.autocommands",
}

function core.load_deps()
    for _, module in ipairs(dependencies) do
        require(module)
    end
end

function core.reload()
    for _, module in ipairs(dependencies) do
        package.loaded[module] = nil
    end
    core.load_deps()
end

return core
