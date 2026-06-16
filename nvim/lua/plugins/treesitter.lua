return {
    "nvim-treesitter/nvim-treesitter",
    branch = 'master',
    build = function()
        require("nvim-treesitter.install").update({ with_sync = true })()
    end,
    config = function()
        require("nvim-treesitter.configs").setup({
            ensure_installed = { 'c', 'cpp', 'python', 'glsl', 'rust' },
            sync_install = false,
            auto_install = false,
            highlight = { enable = true },
            additional_vim_regex_highlighting = false,
        })
    end
}
