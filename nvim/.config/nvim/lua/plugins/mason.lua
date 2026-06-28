return {
    {
        "williamboman/mason.nvim",
        config = true,
    },

    {
        "williamboman/mason-lspconfig.nvim",
        dependencies = {
            "mason.nvim",
            "neovim/nvim-lspconfig",
        },

        opts = {
            ensure_installed = _G.NVIM_LSP_SERVERS or {},
        },
    },
}
