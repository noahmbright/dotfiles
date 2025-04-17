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

        require('telescope').setup {
            pickers = {
                find_files = {
                    theme = 'ivy'
                },
                live_grep = {
                    theme = 'ivy'
                }
            }
        }

        local telescope_builtin = require('telescope.builtin')
        vim.keymap.set('n', '<leader><Space>', telescope_builtin.buffers, {})
        vim.keymap.set('n', '<leader>ff', telescope_builtin.find_files, {})
        vim.keymap.set('n', '<leader>fg', telescope_builtin.live_grep, {})
        vim.keymap.set('n', '<leader>fs', telescope_builtin.grep_string, {})
        vim.keymap.set('n', '<leader>fb', telescope_builtin.current_buffer_fuzzy_find, {})
        vim.keymap.set('n', '<leader>fh', telescope_builtin.help_tags, {})
        vim.keymap.set('n', '<leader>fd', telescope_builtin.diagnostics, {})
        vim.keymap.set('n', '<leader>ds', telescope_builtin.lsp_document_symbols, {})
        vim.keymap.set('n', '<leader>ws', telescope_builtin.lsp_dynamic_workspace_symbols, {})
        vim.keymap.set('n', '<leader>fp', telescope_builtin.man_pages, {})
        vim.keymap.set('n', '<leader>fm', telescope_builtin.marks, {})

        vim.keymap.set('n', '<leader>ft', function()
            vim.cmd(":Telescope builtin")
        end, {})

        vim.keymap.set('n', '<leader>fn', function()
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

        vim.keymap.set('n', '<leader>gp', function()
                telescope_builtin.live_grep({
                    prompt_title = 'Grep Python',
                    additional_args = {
                        '--glob=*.py'
                    }
                })
            end,
            { desc = 'grep python' }
        )

        vim.keymap.set('n', '<leader>gup', function()
                telescope_builtin.live_grep({
                    prompt_title = 'Grep Python',
                    default_text = vim.fn.expand("<cword>"),
                    additional_args = {
                        '--glob=*.py'
                    }
                })
            end,
            { desc = 'grep under python' }
        )


        vim.keymap.set('n', '<leader>gh', function()
                telescope_builtin.live_grep({
                    prompt_title = 'Grep Headers',
                    additional_args = {
                        '--glob=*.h'
                    }
                })
            end,
            { desc = 'grep headers' }
        )

        vim.keymap.set('n', '<leader>guh', function()
                telescope_builtin.live_grep({
                    default_text = vim.fn.expand("<cword>"),
                    prompt_title = 'Grep Headers',
                    additional_args = {
                        '--glob=*.h'
                    }
                })
            end,
            { desc = 'grep under headers' }
        )

        vim.keymap.set('n', '<leader>gi', function()
                telescope_builtin.live_grep({
                    prompt_title = 'Grep Implementation',
                    additional_args = {
                        '--glob=*.c',
                        '--glob=*.cpp',
                        '--glob=*.cxx',
                        '--glob=*.cc',
                    }
                })
            end,
            { desc = 'grep implementation' }
        )

        vim.keymap.set('n', '<leader>gui', function()
                telescope_builtin.live_grep({
                    default_text = vim.fn.expand("<cword>"),
                    prompt_title = 'Grep Implementation',
                    additional_args = {
                        '--glob=*.c',
                        '--glob=*.cpp',
                        '--glob=*.cxx',
                        '--glob=*.cc',
                    }
                })
            end,
            { desc = 'grep under implementation' }
        )



        --To look at what default configuration options exist please read: :help telescope.setup().
        --For picker specific opts please read: :help telescope.builtin.
    end

}
