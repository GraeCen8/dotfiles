return {
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function()
            require("nvim-treesitter.config").setup({
                ensure_installed = {
                    "lua",
                    "vim",
                    "vimdoc",
                    "bash",
                    "python",
                    "javascript",
                    "typescript",
                    "html",
                    "css",
                    "json",
                    "yaml",
                    "markdown",
                    "markdown_inline",
                    "go",
                    "rust",
                    "zsh",
                },

                highlight = {
                    enable = true,
                },

                indent = {
                    enable = true,
                },
            })
        end,
    },
}
