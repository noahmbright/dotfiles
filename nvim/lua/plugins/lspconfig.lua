-- help lsp
-- help vim.lsp. {buf, ...}
local on_attach = function()
    vim.keymap.set('n', "K", vim.lsp.buf.hover, { buffer = 0 })
    vim.keymap.set('n', "<c-k>", vim.lsp.buf.signature_help, { buffer = 0 })
    vim.keymap.set('n', "gd", vim.lsp.buf.definition, { buffer = 0 })
    vim.keymap.set('n', "td", vim.lsp.buf.type_definition, { buffer = 0 })
    vim.keymap.set('n', "gi", vim.lsp.buf.implementation, { buffer = 0 })
    vim.keymap.set('n', "<leader>rn", vim.lsp.buf.rename, { buffer = 0 })
    vim.keymap.set('n', "<leader>ca", vim.lsp.buf.code_action, { buffer = 0 })
end


local M = {
    "neovim/nvim-lspconfig",

    config = function()
        vim.lsp.config['rust_analyzer'] = {
            on_attach = on_attach,
        }

        vim.lsp.config['pylsp'] = {
            on_attach = on_attach,
        }

        vim.lsp.config['clangd'] = {
            on_attach = on_attach,
            cmd = {
                'clangd',
                '--log=verbose',
                '--pretty',
            },
        }

        vim.lsp.config['lua_ls'] = {
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

        vim.lsp.config['tsserver'] = {
            init_options = {
                hostInfo = "neovim",
            },
        }

        vim.lsp.enable({ 'tsserver', 'rust_analyzer', 'pylsp', 'lua_ls', 'clangd' })
    end
}

return M
