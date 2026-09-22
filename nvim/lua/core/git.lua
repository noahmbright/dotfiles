local M = {}

_G.git_branch_cache = {}

function get_git_branch_string()
    local bufnr = vim.api.nvim_get_current_buf()
    if _G.git_branch_cache[bufnr] ~= nil then
        return _G.git_branch_cache[bufnr]
    end

    local file_path = vim.api.nvim_buf_get_name(bufnr)
    if file_path == '' then return 'Not in a repo' end

    local cwd = vim.fn.fnamemodify(file_path, ":h")
    local cmd = 'git -C ' .. vim.fn.shellescape(cwd) .. ' rev-parse --abbrev-ref HEAD 2>/dev/null'
    local handle = io.popen(cmd)
    local branch = handle and handle:read('*l') or 'Not in a repo'
    if handle then handle:close() end

    _G.git_branch_cache[bufnr] = branch
    return branch
end

vim.api.nvim_create_autocmd('BufDelete', {
    callback = function(args)
        _G.git_branch_cache[args.buf] = nil
    end
})

local function open_git_conflicts()
    -- --diff-filter=U: restrict to Unmerged files, i.e. those with conflict markers
    local files = vim.fn.systemlist('git diff --name-only --diff-filter=U 2>/dev/null')
    -- vim.v.shell_error: exit code of the last shell command; nonzero means git failed (not in a repo, etc.)
    -- #files: Lua's length operator on a table
    if vim.v.shell_error ~= 0 or #files == 0 then
        print('No merge conflicts found')
        return
    end

    -- shellescape each path and join so grep gets one invocation across all files
    -- -n: prefix matches with line number; -H: always include filename (needed when only one file)
    local escaped = table.concat(vim.tbl_map(vim.fn.shellescape, files), ' ')
    local matches = vim.fn.systemlist('grep -nH "^<<<<<<<" ' .. escaped)
    if #matches == 0 then
        print('Conflict files found but no markers — try :edit on each file')
        return
    end

    local qf_items = {}
    for _, match in ipairs(matches) do
        -- grep output: "path/to/file:42:<<<<<<< HEAD"
        -- (.-)  lazy match so the first : splits filename from lnum (handles paths with colons)
        local file, lnum = match:match('^(.-)%:(%d+)%:')
        if file and lnum then
            table.insert(qf_items, { filename = file, lnum = tonumber(lnum), text = 'Conflict' })
        end
    end

    vim.fn.setqflist(qf_items)
    vim.cmd('copen')
    vim.cmd('cfirst')
end

local function show_git_blame()
    local file = vim.api.nvim_buf_get_name(0)
    if file == '' then print('No file') return end

    local line = vim.api.nvim_win_get_cursor(0)[1]
    local raw = vim.fn.systemlist(
        'git blame --porcelain -L ' .. line .. ',' .. line .. ' -- ' .. vim.fn.shellescape(file) .. ' 2>/dev/null'
    )
    if vim.v.shell_error ~= 0 or #raw == 0 then print('Not in a git repo or file untracked') return end

    -- porcelain format: first line is "<hash> <orig> <final>", then "key value" pairs, then "\t<line content>"
    local hash = raw[1]:match('^(%x+)')
    local info = {}
    for _, l in ipairs(raw) do
        local k, v = l:match('^([%a-]+) (.+)')
        if k then info[k] = v end
    end

    local author   = info['author'] or '?'
    local mail     = info['author-mail'] or ''
    local ts       = tonumber(info['author-time'])
    local date_str = ts and os.date('%Y-%m-%d %H:%M', ts) or '?'
    local summary  = info['summary'] or '?'

    -- full commit body (may be empty for simple commits)
    local body_lines = vim.fn.systemlist('git log -1 --format=%b ' .. hash .. ' 2>/dev/null')
    -- strip trailing blank lines
    while #body_lines > 0 and body_lines[#body_lines]:match('^%s*$') do
        table.remove(body_lines)
    end

    local lines = {
        hash:sub(1, 12) .. '  ' .. date_str,
        author .. '  ' .. mail,
        '',
        summary,
    }
    if #body_lines > 0 then
        table.insert(lines, '')
        vim.list_extend(lines, body_lines)
    end

    local width = 0
    for _, l in ipairs(lines) do width = math.max(width, #l) end
    width = math.min(math.max(width, 40), 80)

    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
    vim.bo[buf].modifiable = false

    local win = vim.api.nvim_open_win(buf, false, {
        relative = 'cursor', row = 1, col = 0,
        width = width, height = #lines,
        style = 'minimal', border = 'rounded',
    })
    vim.wo[win].wrap = false

    -- close on any movement or action
    vim.api.nvim_create_autocmd({ 'CursorMoved', 'BufLeave', 'InsertEnter' }, {
        once = true,
        callback = function()
            if vim.api.nvim_win_is_valid(win) then vim.api.nvim_win_close(win, true) end
        end,
    })
end

vim.api.nvim_create_user_command('GitBlame', show_git_blame, { desc = 'Show git blame for current line' })

vim.api.nvim_create_user_command('GitConflicts', open_git_conflicts, { desc = 'Open git conflict markers in quickfix' })
vim.keymap.set('n', '<leader>gc', open_git_conflicts, { noremap = true, desc = 'Open git conflicts in quickfix' })

M.get_git_branch_string = get_git_branch_string
return M
