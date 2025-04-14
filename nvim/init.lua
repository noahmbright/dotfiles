-- https://github.com/VonHeikemen/nvim-starter
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.g.have_nerd_font = true

local core = require("core")
require("plugins")

vim.cmd("colorscheme kanagawa")
require("core.statusline").set_statusline_highlights()
_G.cached_mode = string.format(' Normal ')

local function load_dependencies(dependencies)
    for _, module in ipairs(dependencies) do
        require(module)
    end
end

local function reload_dependencies(dependencies)
    for _, module in ipairs(dependencies) do
        package.loaded[module] = nil
    end
    load_dependencies(dependencies)
end

local function reload()
    if not core.dependencies then
        print "core.dependencies is nil, not reloading"
        return
    end

    package.loaded["core"] = nil
    package.loaded["plugins"] = nil
    core = require("core")
    require("plugins")
    reload_dependencies(core.dependencies)
    print "reloaded config"
end

vim.keymap.set('n', "<leader>rl", reload)
load_dependencies(core.dependencies)
