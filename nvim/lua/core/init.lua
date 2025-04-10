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

-- https://github.com/VonHeikemen/nvim-starter

require "nvim-treesitter".setup()
-- treesitter config

--telescope
-- cwd to set working dir
require('telescope').load_extension('fzf')
--telescope

--lspconfig
-- help vim.lsp. {buf, ...}
local on_attach = function()
    vim.keymap.set('n', "K", vim.lsp.buf.hover, { buffer = 0 })
    vim.keymap.set('n', "<c-k>", vim.lsp.buf.signature_help, { buffer = 0 })
    vim.keymap.set('n', "gd", vim.lsp.buf.definition, { buffer = 0 })
    vim.keymap.set('n', "td", vim.lsp.buf.type_definition, { buffer = 0 })
    vim.keymap.set('n', "gi", vim.lsp.buf.implementation, { buffer = 0 })
    vim.keymap.set('n', "<leader>dn", function() vim.diagnostic.jump({ count = 1, float = true }) end, { buffer = 0 })
    vim.keymap.set('n', "<leader>dp", function() vim.diagnostic.jump({ count = -1, float = true }) end, { buffer = 0 })
    vim.keymap.set('n', "<leader>r", vim.lsp.buf.rename, { buffer = 0 })
    vim.keymap.set('n', "<leader>ca", vim.lsp.buf.code_action, { buffer = 0 })
end

require 'lspconfig'.rust_analyzer.setup {
    on_attach = on_attach,
}

require 'lspconfig'.pyright.setup {
    on_attach = on_attach,
}

require 'lspconfig'.clangd.setup({
    on_attach = on_attach,
    cmd = { 
        'clangd',
        '--log=verbose',
        '--pretty',
    },
})
require 'lspconfig'.lua_ls.setup {
    cmd = { "lua-language-server" },
    on_attach = on_attach,
    settings = {
        Lua = {
            runtime = {
                version = 'LuaJIT',
            },
            diagnostics = {
                globals = { 'vim' },
            }
        },
    },
}






-- nvimdap
local dap, dapui = require("dap"), require("dapui")
dap.adapters.lldb = {
    type = 'executable',
    command = '/opt/homebrew/opt/llvm/bin/lldb-dap', -- adjust as needed, must be absolute path
    name = 'lldb'
}

dap.configurations.c = {
    {
        name = 'Launch',
        type = 'lldb',
        request = 'launch',
        program = function()
            return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
        end,
        args = function()
            return vim.fn.input('Command line args: ')
        end,
        cwd = '${workspaceFolder}',
        stopOnEntry = false,

        -- 💀
        -- if you change `runInTerminal` to true, you might need to change the yama/ptrace_scope setting:
        --
        --    echo 0 | sudo tee /proc/sys/kernel/yama/ptrace_scope
        --
        -- Otherwise you might get the following error:
        --
        --    Error on launch: Failed to attach to the target process
        --
        -- But you should be aware of the implications:
        -- https://www.kernel.org/doc/html/latest/admin-guide/LSM/Yama.html
        -- runInTerminal = false,
    },
}

dap.configurations.cpp = dap.configurations.c


require "dapui".setup()

dap.listeners.before.attach.dapui_config = function()
    dapui.open()
end
dap.listeners.before.launch.dapui_config = function()
    dapui.open()
end
dap.listeners.before.event_terminated.dapui_config = function()
    dapui.close()
end
dap.listeners.before.event_exited.dapui_config = function()
    dapui.close()
end

return core
