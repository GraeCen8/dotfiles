require("nvchad.configs.lspconfig").defaults()

local servers = {
  "html",
  "cssls",
  "clangd",
  "typescript-language-server",
  "gopls",
  "ols",
  "svelte-language-sever",
  "tailwind-language-server",
  "rust-analyzer",
}
vim.lsp.enable(servers)
