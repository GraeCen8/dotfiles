require("nvchad.configs.lspconfig").defaults()

local servers = { "html", "cssls", "clangd", "typescript-language-server", "gopls", "ols" }
vim.lsp.enable(servers)

-- read :h vim.lsp.config for changing options of lsp servers 
