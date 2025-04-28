return {
    "nvim-telescope/telescope.nvim",
    branch = '0.1.x',

    dependencies = {
        'nvim-lua/plenary.nvim',
        {
            'nvim-telescope/telescope-fzf-native.nvim',
            build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release'
        },
    },
    opts = {
        defaults = {
            prompt_prefix = "huh ",
        },
        extensions = {
            'fzf',
        },
    },

    config = function()
        require('telescope').load_extension('fzf')

        local theme_settings = {
            theme = 'ivy',
            layout_config = { height = 0.9 },
        }

        require('telescope').setup {
            pickers = {
                find_files = theme_settings,
                live_grep = theme_settings,
                buffers = theme_settings,
                keymaps = theme_settings,
            }
        }

        local telescope_builtin = require('telescope.builtin')
        vim.keymap.set('n', '<leader><Space>', telescope_builtin.buffers, {})
        vim.keymap.set('n', '<leader>ff', telescope_builtin.find_files, {})
        vim.keymap.set('n', '<leader>fn', function() telescope_builtin.find_files({ cwd = '~/notes' }) end, {})
        vim.keymap.set('n', '<leader>gn', function() telescope_builtin.live_grep({ cwd = '~/notes' }) end, {})
        vim.keymap.set('n', '<leader>fg', telescope_builtin.live_grep, {})
        vim.keymap.set('n', '<leader>fs', telescope_builtin.grep_string, {})
        vim.keymap.set('n', '<leader>fb', telescope_builtin.current_buffer_fuzzy_find, {})
        vim.keymap.set('n', '<leader>fh', telescope_builtin.help_tags, {})
        vim.keymap.set('n', '<leader>fd', telescope_builtin.diagnostics, {})
        vim.keymap.set('n', '<leader>ds', telescope_builtin.lsp_document_symbols, {})
        vim.keymap.set('n', '<leader>ws', telescope_builtin.lsp_dynamic_workspace_symbols, {})
        vim.keymap.set('n', '<leader>fp', telescope_builtin.man_pages, {})
        vim.keymap.set('n', '<leader>fm', telescope_builtin.marks, {})
        vim.keymap.set('n', '<leader>fk', telescope_builtin.keymaps, {})

        vim.keymap.set('n', '<leader>ft', function()
            vim.cmd(":Telescope builtin")
        end, {})

        vim.keymap.set('n', '<leader>fc', function()
            telescope_builtin.find_files {
                cwd = vim.fn.stdpath("config")
            }
        end)

        -- grep
        vim.keymap.set('n', '<leader>guw', function()
                telescope_builtin.live_grep({
                    default_text = vim.fn.expand("<cword>"),
                })
            end,
            { desc = 'grep under word' }
        )

        local function make_grep_keymaps(filetype, table_to_glob)
            local lowercase_first_char = filetype:sub(1, 1):lower()
            vim.keymap.set('n', '<leader>gu' .. lowercase_first_char, function()
                    telescope_builtin.live_grep({
                        default_text = vim.fn.expand("<cword>"),
                        prompt_title = 'Grep ' .. filetype,
                        additional_args = table_to_glob,
                    })
                end,
                { desc = 'grep under ' .. filetype }
            )

            vim.keymap.set('n', '<leader>g' .. lowercase_first_char, function()
                    telescope_builtin.live_grep({
                        prompt_title = 'Grep ' .. filetype,
                        additional_args = table_to_glob,
                    })
                end,
                { desc = 'grep ' .. filetype }
            )
        end

        make_grep_keymaps("Python", { '--glob=*.py' })
        make_grep_keymaps("Lua", { '--glob=*.lua' })
        make_grep_keymaps("Headers", { '--glob=*.h', '--glob=*.hpp' })
        make_grep_keymaps("Implementation", {
            '--glob=*.c',
            '--glob=*.cpp',
            '--glob=*.cc',
            '--glob=*.cxx',
        })

        --To look at what default configuration options exist please read: :help telescope.setup().
        --For picker specific opts please read: :help telescope.builtin.
    end

}
