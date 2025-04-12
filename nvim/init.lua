vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
--vim.g.have_nerd_font = true

local core = require("core")
local plugins = require("plugins")
vim.cmd("colorscheme kanagawa")

--[[
    After understanding a bit more about Lua, you can use `:help lua-guide` as a
    reference for how Neovim integrates Lua.
    - :help lua-guide
    - (or HTML version): https://neovim.io/doc/user/lua-guide.html
--]]

local function reload()
    print "reloading"
    package.loaded["core"] = nil
    core = require("core")
    core.reload()
end

vim.keymap.set('n', "<leader>rl", reload)
core.load_deps()
