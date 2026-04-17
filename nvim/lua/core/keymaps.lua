local opts = { noremap = true, silent = true }

vim.keymap.set('n', "<leader>pv", vim.cmd.Ex)

-- [[ Setting options ]]
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
local goto_next_diagnostic = function(n) return function() vim.diagnostic.jump({ count = n, float = true }) end end

vim.keymap.set('n', '[d', goto_next_diagnostic(-1), { desc = 'Go to previous [D]iagnostic message' })
vim.keymap.set('n', ']d', goto_next_diagnostic(1), { desc = 'Go to next [D]iagnostic message' })
vim.keymap.set('n', "<leader>dn", goto_next_diagnostic(1), { buffer = 0 })
vim.keymap.set('n', "<leader>dp", goto_next_diagnostic(-1), { buffer = 0 })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Show diagnostic [E]rror messages' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Keybinds to make split navigation easier.
--  See `:help wincmd` for a list of all window commands
--  :h Q_wi for window commands
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })
vim.api.nvim_create_autocmd("FileType", {
    pattern = "netrw",
    callback = function()
        -- Override <C-l> in netrw to do window movement
        vim.keymap.set("n", "<C-l>", "<C-w>l", { buffer = true, remap = true })
    end,
})

vim.keymap.set('n', '<leader>sv', '<C-w>s', { desc = 'split vertically' })
vim.keymap.set('n', '<leader>sh', '<C-w>v', { desc = 'split horizontally' })
vim.keymap.set('n', '<leader>se', '<C-w>=', { desc = 'equal size split' })
vim.keymap.set('n', '<leader>sx', ':close<CR>', { desc = 'close split' })
vim.keymap.set('n', '<leader>sf', ':tab split<CR>', { desc = 'focus split' })
vim.keymap.set('n', '<leader>su', ':w<CR> :tabc<CR>', { desc = 'focus split' })

vim.api.nvim_set_keymap('n', '<S-Up>', ':resize +2<CR>', opts)
vim.api.nvim_set_keymap('n', '<S-Down>', ':resize -2<CR>', opts)
vim.api.nvim_set_keymap('n', '<S-Left>', ':vertical resize +2<CR>', opts)
vim.api.nvim_set_keymap('n', '<S-Right>', ':vertical resize -2<CR>', opts)

vim.keymap.set('n', '<leader>bd', function()
    local name = vim.api.nvim_buf_get_name(0)
    vim.cmd('bp | sp | bn | bd')
    print("deleted buffer " .. (name ~= "" and name or "[No Name]"))
end, { desc = "delete buffer split w/o closing split" })

vim.keymap.set('n', 'x', '\"_x')

vim.keymap.set('n', '<leader>+', '<C-a>', { desc = 'increment number' })
vim.keymap.set('n', '<leader>-', '<C-x>', { desc = 'decrement number' })

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set('n', "J", "mzJ`z")
vim.keymap.set('n', "<C-d>", "<C-d>zz")
vim.keymap.set('n', "<C-u>", "<C-u>zz")
vim.keymap.set('n', "n", "nzzzv")
vim.keymap.set('n', "N", "Nzzzv")

vim.keymap.set('x', "<leader>P", "\"_dP")

vim.api.nvim_set_keymap('n', '<leader>pf', ':w | :! python3 "%:p"<Enter>',
    { noremap = true, silent = true, desc = 'Run python file' })
vim.api.nvim_set_keymap('n', '<leader>lf', ':w | :! pdflatex "%:p"<Enter>',
    { noremap = true, silent = true, desc = 'pdflatex file' })

vim.keymap.set('n', "<C-a>", "gg<S-v>G", { noremap = true, silent = true, desc = 'select all' })

vim.keymap.set('v', '>', '>gv', opts)
vim.keymap.set('v', '<', '<gv', opts)
vim.keymap.set('v', 'p', '\"_dP', opts)

-- changing directory
local function lcdh()
    local command = ':lcd ' .. vim.fn.expand('%:p:h')
    vim.cmd(command)
    print("local nvim directory is " .. vim.fn.getcwd())
end
vim.keymap.set('n', '<leader>lcdh', lcdh, { noremap = true, desc = 'local cd to current file' })

local function cdh()
    local command = ':cd ' .. vim.fn.expand('%:p:h')
    vim.cmd(command)
    print("global nvim directory is " .. vim.fn.getcwd())
end
vim.keymap.set('n', '<leader>cdh', cdh, { noremap = true, desc = 'global cd to current file' })

vim.keymap.set('n', '<leader>lne',
    function()
        vim.opt.relativenumber = true
        vim.opt.number = true
    end
    ,
    { desc = 'enable line number' }
)

vim.keymap.set('n', '<leader>lnd',
    function()
        vim.opt.relativenumber = false
        vim.opt.number = false
    end
    ,
    { desc = 'disable line number' }
)

vim.keymap.set('n', '<leader>yb', '_v$%y', { desc = 'Yank Block on this line' })

-- git diff current file vs HEAD
local function git_diff_current_file()
    local filepath = vim.fn.expand('%')
    if filepath == '' then
        print('No file in current buffer')
        return
    end

    -- quotes the path for safe shell use (handles spaces, special chars)
    local escaped = vim.fn.shellescape(filepath)
    local raw_output = vim.fn.system('git ls-files --full-name ' .. escaped)

    -- gsub replaces all occurrences; strips trailing newline system() appends
    local git_path = raw_output:gsub('\n', '')
    if git_path == '' then
        print('File ' .. filepath .. ' is not tracked by git')
        return
    end

    -- git show prints a git object's contents
    -- HEAD:<path> means the version of <path> at the most recent commit
    local content = vim.fn.systemlist('git show HEAD:' .. vim.fn.shellescape(git_path))

    -- exit code of last shell command
    if vim.v.shell_error ~= 0 then
        print('No HEAD version found (new or untracked file?)')
        return
    end

    local ft = vim.bo.filetype

    local stale = vim.fn.bufnr('HEAD:' .. git_path) -- bufnr() returns handle by name, -1 if not found
    if stale ~= -1 then vim.api.nvim_buf_delete(stale, { force = true }) end

    local head_buf = vim.api.nvim_create_buf(false, true)       -- (listed=false, scratch=true)
    vim.api.nvim_buf_set_lines(head_buf, 0, -1, false, content) -- 0,-1 replaces all lines
    vim.bo[head_buf].buftype = 'nofile'
    vim.bo[head_buf].bufhidden = 'wipe'
    vim.bo[head_buf].swapfile = false
    vim.bo[head_buf].modifiable = false
    vim.bo[head_buf].filetype = ft
    vim.api.nvim_buf_set_name(head_buf, 'HEAD:' .. git_path)

    vim.cmd('tabnew')
    vim.t.is_git_diff = true -- tab-local flag; vim.t scopes to the current tabpage
    vim.cmd('edit ' .. vim.fn.fnameescape(filepath))

    vim.cmd('leftabove vsplit')
    local head_win = vim.api.nvim_get_current_win()
    vim.api.nvim_win_set_buf(head_win, head_buf)
    vim.cmd('diffthis')

    vim.cmd('wincmd l') -- move to right window (working file)
    vim.cmd('diffthis')
end

vim.keymap.set('n', '<leader>gd', git_diff_current_file, { noremap = true, desc = 'Git diff current file vs HEAD' })

local function git_diff_close()
    if not vim.t.is_git_diff then
        print('Not in a git diff tab')
        return
    end
    local tabpage = vim.api.nvim_get_current_tabpage()
    for _, win in ipairs(vim.api.nvim_tabpage_list_wins(tabpage)) do
        local buf = vim.api.nvim_win_get_buf(win)
        if vim.api.nvim_buf_get_name(buf):match('^HEAD:') then
            vim.api.nvim_buf_delete(buf, { force = true }) -- explicit delete; don't rely on bufhidden
        end
    end
    vim.cmd('tabclose')
end

vim.keymap.set('n', '<leader>gD', git_diff_close, { noremap = true, desc = 'Close git diff tab' })

local num_scratch_buffers = 0
vim.api.nvim_create_user_command('Scratch', function()
        vim.cmd('enew')
        vim.bo.buftype = 'nofile'
        vim.bo.bufhidden = 'hide'
        vim.bo.swapfile = false
        vim.api.nvim_buf_set_name(0, 'scratch' .. num_scratch_buffers)
        num_scratch_buffers = num_scratch_buffers + 1
    end,
    { desc = 'Open a new scratch buffer' })
