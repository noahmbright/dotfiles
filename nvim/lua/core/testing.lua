local test_invocations = {
    rust = 'cargo test ',
    python = 'pytest -k ',
}

local last_test_cmd = ''
local test_terminal_window = nil
local test_terminal_buffer = nil
local test_terminal_job_id = nil

local function test_terminal_buffer_is_valid()
    return test_terminal_buffer and vim.api.nvim_buf_is_valid(test_terminal_buffer)
end

local function test_terminal_window_is_valid()
    return test_terminal_window and vim.api.nvim_win_is_valid(test_terminal_window)
end

local function open_test_terminal_window()
    local width = math.floor(vim.o.columns * 0.8)
    local height = math.floor(vim.o.lines * 0.4)
    test_terminal_window = vim.api.nvim_open_win(test_terminal_buffer, true, {
        relative = 'editor',
        width = width,
        height = height,
        row = math.floor((vim.o.columns - width) / 2),
        col = math.floor((vim.o.lines - height) / 2),
        border = 'rounded'
    })
end

local function create_test_terminal_buffer()
    -- (false, true) false means don't list, true means do use a scratch buffer
    test_terminal_buffer = vim.api.nvim_create_buf(false, true)

    if not vim.api.nvim_buf_is_valid(test_terminal_buffer) then
        print('create_test_terminal_buffer: failed to create terminal buffer')
        return
    end

    open_test_terminal_window()
    test_terminal_job_id = vim.fn.termopen(vim.o.shell or 'zsh' or 'bash')

    vim.cmd('startinsert')
end

local function toggle_test_terminal_window()
    if test_terminal_window_is_valid() then
        vim.api.nvim_win_close(test_terminal_window, true)
        test_terminal_window = nil
    else
        if not test_terminal_buffer_is_valid() then
            create_test_terminal_buffer()
            return
        end
        if test_terminal_buffer_is_valid() then
            open_test_terminal_window()
        else
            print('toggle_test_terminal_window: terminal buffer was invalid')
        end
    end
end

local function send_test_terminal_command(cmd)
    if not test_terminal_buffer_is_valid() or not test_terminal_window_is_valid() then
        toggle_test_terminal_window()
    end

    if test_terminal_job_id then
        vim.fn.chansend(test_terminal_job_id, cmd)
    else
        print('send_test_terminal_command: test_terminal_job_id is nil')
    end
end

vim.keymap.set('n', '<leader>tw', toggle_test_terminal_window, { desc = 'Toggle test window' })

vim.keymap.set('n', '<leader>rut', function()
        local test_name = vim.fn.expand('<cword>')
        local file_extension = vim.bo.filetype
        local invocation = test_invocations[file_extension]
        if invocation ~= '' then
            last_test_cmd = invocation .. test_name .. '\n'
            send_test_terminal_command(last_test_cmd)
        else
            print('Run Test Under Cursor: Don\'t know how to run tests for this filetype')
        end
    end,
    {
        noremap = true,
        silent = true,
        desc = 'Run Test Under cursor'
    })

vim.keymap.set('n', '<leader>rrt', function()
        if last_test_cmd ~= '' then
            send_test_terminal_command(last_test_cmd)
        else
            print('ReRun Test: Haven\'t run anything yet')
        end
    end,
    {
        noremap = true,
        silent = true,
        desc = 'ReRun last Test '
    })
