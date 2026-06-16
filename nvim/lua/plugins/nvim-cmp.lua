return {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",

    dependencies = {
        'hrsh7th/cmp-nvim-lsp',
        'hrsh7th/cmp-path',
        'L3MON4D3/LuaSnip',
        'saadparwaiz1/cmp_luasnip'
    },

    config = function()
        local cmp = require 'cmp'
        local luasnip = require 'luasnip'
        luasnip.config.setup {}

        -- When true, C++ stdlib suggestions (items that would auto-insert a non-.h system header) are shown.
        -- Toggle with <leader>cs in any buffer.
        vim.g.cmp_cpp_stdlib = false

        vim.keymap.set('n', '<leader>cs', function()
            vim.g.cmp_cpp_stdlib = not vim.g.cmp_cpp_stdlib
            print('C++ stdlib completions: ' .. (vim.g.cmp_cpp_stdlib and 'shown' or 'hidden'))
        end, { desc = 'Toggle C++ stdlib completions' })

        -- Returns true if this completion item would auto-insert a C++ stdlib header.
        -- C headers always end in .h (<stdio.h>); C++ stdlib headers never do (<vector>).
        local function is_cpp_stdlib_item(item)
            if not item.additionalTextEdits then return false end
            for _, edit in ipairs(item.additionalTextEdits) do
                local new_text = edit.newText or ''
                -- matches "#include <something>" where something has no .h suffix
                if new_text:match('#include <[^>]+>') and not new_text:match('#include <[^>]+%.h>') then
                    return true
                end
            end
            return false
        end

        cmp.setup({
            snippet = {
                expand = function(args)
                    require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
                end,
            },
            window = {
                completion = cmp.config.window.bordered({ border = 'rounded', side_padding = 1 }),
                documentation = cmp.config.window.bordered({ border = 'rounded', side_padding = 1 }),
            },
            mapping = cmp.mapping.preset.insert({
                ['<C-b>'] = cmp.mapping.scroll_docs(-4),
                ['<C-f>'] = cmp.mapping.scroll_docs(4),
                ['<C-n>'] = cmp.mapping.select_next_item(),
                ['<C-p>'] = cmp.mapping.select_prev_item(),
                ['<C-Space>'] = cmp.mapping.complete(),
                ['<C-e>'] = cmp.mapping.abort(),
                ['<C--y>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
                ['<C-l>'] = cmp.mapping(function()
                    if luasnip.expand_or_locally_jumpable() then
                        luasnip.expand_or_jump()
                    end
                end, { 'i', 's' }),
                ['<C-h>'] = cmp.mapping(function()
                    if luasnip.locally_jumpable(-1) then
                        luasnip.jump(-1)
                    end
                end, { 'i', 's' }),
            }),
            sources = cmp.config.sources({
                {
                    name = 'nvim_lsp',
                    entry_filter = function(entry)
                        if vim.g.cmp_cpp_stdlib then return true end
                        return not is_cpp_stdlib_item(entry:get_completion_item())
                    end,
                },
                { name = 'luasnip' },
            }, {
                { name = 'buffer' },
                { name = 'path' },
            })
        })

        -- Set up lspconfig.
        --local capabilities = require('cmp_nvim_lsp').default_capabilities()
        -- Replace <YOUR_LSP_SERVER> with each lsp server you've enabled.
        --require('lspconfig')['<YOUR_LSP_SERVER>'].setup {
        --capabilities = capabilities
        --}
    end
}
