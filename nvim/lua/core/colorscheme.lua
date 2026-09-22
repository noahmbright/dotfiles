local variant = vim.g.tuke_variant or 'default'

local palettes = {
    default = {
        bg        = '#1e2030',
        bg_subtle = '#2d3149',
        bg_select = '#383e6b',
        fg        = '#c8d3f5',
        fg_dim    = '#636da6',
        red       = '#ff757f',
        orange    = '#ff966c',
        yellow    = '#ffc777',
        green     = '#c3e88d',
        teal      = '#4fd6be',
        blue      = '#82aaff',
        purple    = '#c099ff',
        pink      = '#fca7ea',
    },
    dark = {
        bg        = '#0d1117',
        bg_subtle = '#161b22',
        bg_select = '#21262d',
        fg        = '#e6edf3',
        fg_dim    = '#484f58',
        red       = '#ff7b72',
        orange    = '#ffa657',
        yellow    = '#e3b341',
        green     = '#7ee787',
        teal      = '#39d353',
        blue      = '#79c0ff',
        purple    = '#d2a8ff',
        pink      = '#f778ba',
    },
}

local p = palettes[variant] or palettes.default

vim.cmd('highlight clear')
vim.g.colors_name = variant == 'default' and 'tuke' or 'tuke-' .. variant

local function hi(group, opts)
    vim.api.nvim_set_hl(0, group, opts)
end

-- ── Base ─────────────────────────────────────────────────────────────────────
hi('Normal',          { fg = p.fg,     bg = p.bg })
hi('NormalFloat',     { fg = p.fg,     bg = p.bg_subtle })
hi('FloatBorder',     { fg = p.fg_dim })
hi('Comment',         { fg = p.fg_dim, italic = true })
hi('CursorLine',      { bg = p.bg_subtle })
hi('Visual',          { bg = p.bg_select })
hi('Search',          { fg = p.bg,     bg = p.yellow })
hi('IncSearch',       { fg = p.bg,     bg = p.orange })
hi('LineNr',          { fg = p.fg_dim, bg = p.bg_subtle })
hi('CursorLineNr',    { fg = p.yellow, bold = true, bg = p.bg_subtle })
hi('SignColumn',      { bg = p.bg_subtle })
hi('WinSeparator',    { fg = p.bg_subtle })
hi('StatusLine',      { fg = p.fg,     bg = p.bg_subtle })
hi('StatusLineNC',    { fg = p.fg_dim, bg = p.bg_subtle })
hi('Pmenu',           { fg = p.fg,     bg = p.bg_subtle })
hi('PmenuSel',        { fg = p.bg,     bg = p.blue })
hi('PmenuSbar',       { bg = p.bg_select })

-- ── Syntax (treesitter inherits these by default) ─────────────────────────────
hi('String',          { fg = p.green })
hi('Number',          { fg = p.orange })
hi('Boolean',         { fg = p.orange })
hi('Keyword',         { fg = p.purple })
hi('Operator',        { fg = p.teal })
hi('Function',        { fg = p.blue })
hi('Type',            { fg = p.yellow })
hi('Constant',        { fg = p.orange })
hi('Identifier',      { fg = p.fg })
hi('PreProc',         { fg = p.teal })
hi('Special',         { fg = p.pink })
hi('Error',           { fg = p.red })
hi('Todo',            { fg = p.bg, bg = p.yellow, bold = true })
hi('Delimiter',       { fg = p.fg_dim })

-- ── Diagnostics ───────────────────────────────────────────────────────────────
hi('DiagnosticError',          { fg = p.red })
hi('DiagnosticWarn',           { fg = p.yellow })
hi('DiagnosticInfo',           { fg = p.blue })
hi('DiagnosticHint',           { fg = p.teal })
hi('DiagnosticUnderlineError', { sp = p.red,    undercurl = true })
hi('DiagnosticUnderlineWarn',  { sp = p.yellow, undercurl = true })

-- ── Treesitter ────────────────────────────────────────────────────────────────
hi('@variable',         { fg = p.fg })
hi('@variable.member',  { fg = p.teal })
hi('@variable.builtin', { fg = p.orange, italic = true })
hi('@string.escape',    { fg = p.pink })
hi('@keyword.return',   { fg = p.red,    italic = true })
hi('@function.builtin', { fg = p.blue,   italic = true })
hi('@constructor',      { fg = p.yellow })
hi('@parameter',        { fg = p.fg })
hi('@namespace',        { fg = p.yellow })
hi('@type.builtin',     { fg = p.yellow, italic = true })
hi('@comment.todo',     { fg = p.bg, bg = p.yellow, bold = true })

-- ── LSP semantic tokens ───────────────────────────────────────────────────────
hi('@lsp.type.variable',               { fg = p.fg })
hi('@lsp.typemod.variable.readonly',   { fg = p.orange })
hi('@lsp.type.property',               { fg = p.teal })
hi('@lsp.typemod.property.readonly',   { fg = p.pink })
hi('@lsp.type.builtinType',          { fg = p.yellow })
hi('@lsp.typemod.type.typedef',      { fg = p.pink })
hi('@lsp.type.enum',                 { fg = p.yellow })
hi('@lsp.type.enumMember',           { fg = p.green })
hi('@lsp.type.macro',                { fg = p.purple })

-- ── Telescope ─────────────────────────────────────────────────────────────────
hi('TelescopeBorder',       { fg = p.fg_dim })
hi('TelescopePromptBorder', { fg = p.blue })
hi('TelescopeSelection',    { bg = p.bg_select })
hi('TelescopeMatching',     { fg = p.blue,   bold = true })
hi('TelescopePromptPrefix', { fg = p.purple })

-- ── Markdown ──────────────────────────────────────────────────────────────────
-- Set after ColorScheme fires so treesitter doesn't clobber them.
local red, orange, yellow = p.red, p.orange, p.yellow
vim.api.nvim_create_autocmd('ColorScheme', {
    pattern = { 'tuke', 'tuke-dark' },
    callback = function()
        vim.api.nvim_set_hl(0, '@markup.heading.1.markdown', { fg = red,    bold = true })
        vim.api.nvim_set_hl(0, '@markup.heading.2.markdown', { fg = orange, bold = true })
        vim.api.nvim_set_hl(0, '@markup.heading.3.markdown', { fg = yellow })
    end,
})
