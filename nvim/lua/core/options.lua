-- See `:help vim.opt`
--  For more options, you can see `:help option-list`
-- vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.number = true
vim.opt.mouse = 'a'
vim.opt.showmode = false
vim.opt.clipboard = 'unnamedplus' --  See `:help 'clipboard'`
vim.opt.breakindent = true        -- Enable break indent
vim.opt.undofile = true           -- Save undo history

vim.g.font = "NONE"

vim.opt.cursorline = true
vim.opt.breakindent = true
vim.opt.completeopt = "menu,menuone,popup,fuzzy,noselect"

vim.opt.mouse = 'a'

-- Case-insensitive searching UNLESS \C or capital in search
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Keep signcolumn on by default
vim.opt.signcolumn = 'yes'

--Decrease update time
vim.opt.updatetime = 1000
vim.opt.timeoutlen = 5000

vim.opt.scrolloff = 8

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Sets how neovim will display certain whitespace in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

vim.opt.wrap = false

vim.opt.termguicolors = true
--vim.opt.colorcolumn = "200"
vim.opt.background = "dark"
vim.opt.signcolumn = "yes"

-- Preview substitutions live, as you type!
vim.opt.inccommand = 'split'

vim.opt.cursorline = true
vim.opt.scrolloff = 10 -- Minimal number of screen lines to keep above and below the cursor.

-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Set highlight on search, but clear on pressing <Esc> in normal mode
vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.o.tabstop = 4      -- A TAB character looks like 4 spaces
vim.o.expandtab = true -- Pressing the TAB key will insert spaces instead of a TAB character
vim.o.softtabstop = 4  -- Number of spaces inserted instead of a TAB character
vim.o.shiftwidth = 4   -- Number of spaces inserted when indenting
