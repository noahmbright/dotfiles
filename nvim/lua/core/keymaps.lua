local opts = { noremap = true, silent = true }

vim.keymap.set('n', "<leader>pv", vim.cmd.Ex)

-- [[ Setting options ]]
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous [D]iagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next [D]iagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Show diagnostic [E]rror messages' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Keybinds to make split navigation easier.
--  See `:help wincmd` for a list of all window commands
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

vim.keymap.set('n', '<leader>bd', ':bp | sp | bn | bd<CR>', { desc = "delete buffer split w/o closing split" })

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
