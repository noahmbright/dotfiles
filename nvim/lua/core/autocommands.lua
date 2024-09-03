-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`
--
--  See `:help vim.highlight.on_yank()`
--  dont understand groups yet
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

vim.api.nvim_create_autocmd("BufWrite", {
    desc = "format on write",
    callback = function()
        vim.lsp.buf.format()
    end
})
