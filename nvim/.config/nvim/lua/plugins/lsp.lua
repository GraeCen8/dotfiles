return {
    {
        "neovim/nvim-lspconfig",

        config = function()
            local servers = _G.NVIM_LSP_SERVERS or {}

            for _, server in ipairs(servers) do
                vim.lsp.config(server, {})
                vim.lsp.enable(server)
            end

            vim.keymap.set("n", "gd", vim.lsp.buf.definition)
            vim.keymap.set("n", "gr", vim.lsp.buf.references)
            vim.keymap.set("n", "K", vim.lsp.buf.hover)
            vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename)
            vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action)
            vim.keymap.set("n", "[d", vim.diagnostic.goto_prev)
            vim.keymap.set("n", "]d", vim.diagnostic.goto_next)
        end,
    },
}
