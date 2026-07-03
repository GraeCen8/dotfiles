require("nvchad.configs.lspconfig").defaults()

local servers = { "html", "cssls", "tailwindcss", "clangd", "ols", "zls", "ts_ls", "svelte", "pyright", "rust_analyzer", "gopls" }
vim.lsp.enable(servers)

-- read :h vim.lsp.config for changing options of lsp servers 
