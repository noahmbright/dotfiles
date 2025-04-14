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

M.get_git_branch_string = get_git_branch_string
return M
