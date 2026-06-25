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

        -- <C-s> in live_grep: snapshot current matches into a filename-only filter picker.
        -- Typing in the new prompt narrows by filename while keeping full match context and jump targets.
        local function grep_filter_by_filename(_, map)
            map('i', '<C-s>', function(prompt_bufnr)
                local state = require('telescope.actions.state')
                local picker = state.get_current_picker(prompt_bufnr)

                -- strip the prompt prefix to get just the typed query, so <C-s> can restore it
                local raw = vim.api.nvim_buf_get_lines(picker.prompt_bufnr, 0, 1, false)[1] or ''
                local original_query = raw:sub(#picker.prompt_prefix + 1)

                -- collect all current grep result entries before closing
                local entries = {}
                for i = 1, picker.manager:num_results() do
                    local entry = picker.manager:get_entry(i)
                    if entry and entry.filename then table.insert(entries, entry) end
                end

                require('telescope.actions').close(prompt_bufnr)
                local conf = require('telescope.config').values

                vim.schedule(function()
                    require('telescope.pickers').new(
                    require('telescope.themes').get_ivy({ layout_config = { height = 0.9 } }), {
                        prompt_title = 'Filter matches by filename  |  <C-s> to return',
                        -- ordinal is filename only, so typing filters by file rather than match content
                        finder = require('telescope.finders').new_table {
                            results = entries,
                            entry_maker = function(e)
                                return {
                                    value = e.value,
                                    display = vim.fn.fnamemodify(e.filename, ':~:.') ..
                                    ':' .. e.lnum .. ': ' .. (e.text or ''),
                                    ordinal = e.filename,
                                    path = e.filename,
                                    lnum = e.lnum,
                                    col = e.col,
                                }
                            end,
                        },
                        sorter = conf.generic_sorter({}),
                        previewer = conf.grep_previewer({}),
                        attach_mappings = function(inner_bufnr, map2)
                            -- center the preview window on the matched line each time a new entry is shown
                            local au = vim.api.nvim_create_autocmd('User', {
                                pattern = 'TelescopePreviewerLoaded',
                                callback = function()
                                    local p = state.get_current_picker(inner_bufnr)
                                    if p and p.previewer and p.previewer.state then
                                        local win = p.previewer.state.winid
                                        if win and vim.api.nvim_win_is_valid(win) then
                                            vim.api.nvim_win_call(win, function() vim.cmd('norm! zz') end)
                                        end
                                    end
                                end,
                            })
                            -- remove the autocmd when the picker closes to avoid leaking it
                            vim.api.nvim_create_autocmd('BufWipeout', {
                                buffer = inner_bufnr,
                                once = true,
                                callback = function() pcall(vim.api.nvim_del_autocmd, au) end,
                            })
                            -- toggle back to the original live_grep with the same query
                            local function return_to_grep(prompt_bufnr2)
                                require('telescope.actions').close(prompt_bufnr2)
                                vim.schedule(function()
                                    require('telescope.builtin').live_grep({ default_text = original_query })
                                end)
                            end
                            map2('i', '<C-s>', return_to_grep)
                            map2('n', '<C-s>', return_to_grep)
                            return true
                        end,
                    }):find()
                end)
            end)
            return true
        end

        require('telescope').setup {
            defaults = {
                mappings = {
                    i = {
                        ["<C-f>"] = require('telescope.actions').to_fuzzy_refine,
                    }
                }
            },
            pickers = {
                find_files = theme_settings,
                live_grep = vim.tbl_extend('force', theme_settings, { attach_mappings = grep_filter_by_filename }),
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
        vim.keymap.set('n', '<leader>fl', telescope_builtin.resume, {})

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
        vim.keymap.set('x', '<leader>guw', function()
                local sel = table.concat(vim.fn.getregion(vim.fn.getpos('v'), vim.fn.getpos('.')), ' ')
                telescope_builtin.live_grep({ default_text = sel })
            end,
            { desc = 'grep selection' }
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
            vim.keymap.set('x', '<leader>gu' .. lowercase_first_char, function()
                    local sel = table.concat(vim.fn.getregion(vim.fn.getpos('v'), vim.fn.getpos('.')), ' ')
                    telescope_builtin.live_grep({
                        default_text = sel,
                        prompt_title = 'Grep ' .. filetype,
                        additional_args = table_to_glob,
                    })
                end,
                { desc = 'grep selection ' .. filetype }
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

        make_grep_keymaps("Verilog", { '--glob=*.v' })
        make_grep_keymaps("Python", { '--glob=*.py' })
        make_grep_keymaps("Lua", { '--glob=*.lua' })
        make_grep_keymaps("Headers", { '--glob=*.h', '--glob=*.hpp' })
        make_grep_keymaps("Implementation", {
            '--glob=*.c',
            '--glob=*.cpp',
            '--glob=*.cc',
            '--glob=*.cxx',
        })
        vim.keymap.set('n', '<leader>gb', function()
            telescope_builtin.live_grep({
                grep_open_files = true,
                prompt_title = 'Grep Buffers',
            })
        end, { desc = 'Grep Buffers' })

        --To look at what default configuration options exist please read: :help telescope.setup().
        --For picker specific opts please read: :help telescope.builtin.
    end

}
