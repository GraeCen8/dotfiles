return {
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function()
            local languages = _G.NVIM_TREESITTER_LANGUAGES or {}

            require("nvim-treesitter.config").setup({
                ensure_installed = languages,

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
