return {
    "nvim-treesitter/nvim-treesitter",
    build = function()
        require("nvim-treesitter.install").update({ with_sync = true })()
    end,
    dependencies = {
        'nvim-treesitter/nvim-treesitter-textobjects'
    },
    config = function()
        local config = require "nvim-treesitter.configs"
        config.setup({
            ensure_installed = { 'lua', 'c', 'cpp', 'python', 'cmake', 'glsl', 'rust', 'haskell', 'vim', 'llvm' }, --, 'vimdoc', 'query' }, -- read lua
            sync_install = false,
            auto_install = false,
            highlight = { enable = true },
            additional_vim_regex_highlighting = false,
            incremental_selection = {
                enable = true,
                keymaps = {
                    init_selection = "<Leader>is", -- set to `false` to disable one of the mappings
                    node_incremental = "<Leader>ns",
                    scope_incremental = "<Leader>ss",
                    node_decremental = "<Leader>ds",
                },
            },
        })
    end
}
