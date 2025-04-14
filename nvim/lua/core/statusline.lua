-- help highlight groups
-- help statusline

-- mode
local function update_cached_mode()
    local modes = {
        n = 'Normal',
        i = 'Insert',
        v = 'Visual',
        V = 'V Line',
        [''] = 'V Block',
        c = 'Command',
        s = 'Select',
        S = 'S Line',
        R = 'Replace',
        t = 'Terminal',
    }
    local mode_code = vim.api.nvim_get_mode().mode
    local width = 12
    local mode_string = modes[mode_code] or mode_code
    local length = vim.fn.strdisplaywidth(mode_string)
    local remaining = width - length
    local left = math.floor(remaining / 2)
    local right = remaining - left
    local string_to_render = string.rep(' ', left + 1) .. mode_string .. string.rep(' ', right)
    _G.cached_mode = string.format('%-' .. width .. 's', string_to_render)
end

vim.api.nvim_create_autocmd({ 'ModeChanged', 'VimEnter' }, { callback = update_cached_mode })

function GetVimMode()
    return _G.cached_mode
end

-- highlight groups

function set_statusline_highlights()
    local statusline = vim.api.nvim_get_hl(0, { name = 'StatusLine' })
    vim.api.nvim_set_hl(0, 'StatusLineMode', {
        fg = statusline.bg,
        bg = statusline.fg,
        bold = false
    })

    local visual = vim.api.nvim_get_hl(0, { name = 'Comment' })
    vim.api.nvim_set_hl(0, 'StatusLineGit', {
        fg = visual.bg,
        bg = visual.fg,
        bold = false
    })
end

vim.api.nvim_create_autocmd({ 'VimEnter', 'ColorScheme' }, { callback = set_statusline_highlights })

vim.o.statusline = table.concat({
    '%#StatusLineMode#', '%{v:lua.GetVimMode()}',
    '%#StatusLineGit#', ' %{v:lua.get_git_branch_string()} ',
    '%#Normal#', ' %F',
    '%m',
    '%r',
    '%w',
    ' %y',
    ' (%l, %v)',
    ' %p%%'
})

local M = {}
M.set_statusline_highlights = set_statusline_highlights
return M
