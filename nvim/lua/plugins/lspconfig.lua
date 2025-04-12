-- help lsp
-- help vim.lsp. {buf, ...}
local on_attach = function()
    vim.keymap.set('n', "K", vim.lsp.buf.hover, { buffer = 0 })
    vim.keymap.set('n', "<c-k>", vim.lsp.buf.signature_help, { buffer = 0 })
    vim.keymap.set('n', "gd", vim.lsp.buf.definition, { buffer = 0 })
    vim.keymap.set('n', "td", vim.lsp.buf.type_definition, { buffer = 0 })
    vim.keymap.set('n', "gi", vim.lsp.buf.implementation, { buffer = 0 })
    vim.keymap.set('n', "<leader>dn", function() vim.diagnostic.jump({ count = 1, float = true }) end, { buffer = 0 })
    vim.keymap.set('n', "<leader>dp", function() vim.diagnostic.jump({ count = -1, float = true }) end, { buffer = 0 })
    vim.keymap.set('n', "<leader>rn", vim.lsp.buf.rename, { buffer = 0 })
    vim.keymap.set('n', "<leader>ca", vim.lsp.buf.code_action, { buffer = 0 })
end


local M = {
    "neovim/nvim-lspconfig",
    dependencies = { 'hrsh7th/cmp-nvim-lsp' },

    config = function()
        local lspconfig = require("lspconfig")

        lspconfig.rust_analyzer.setup {
            on_attach = on_attach,
        }

        lspconfig.pyright.setup {
            on_attach = on_attach,
        }

        lspconfig.clangd.setup({
            on_attach = on_attach,
            cmd = {
                'clangd',
                '--log=verbose',
                '--pretty',
            },
        })

        lspconfig.lua_ls.setup {
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
    end
}



return M
