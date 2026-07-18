require("nvchad.configs.lspconfig").defaults()

local servers = {
  "html",
  "cssls",
  "clangd",
  "vtsls",
  "gopls",
  "ols",
  "svelte",
  "tailwindcss",
  "eslint",
  "jsonls",
  "astro",
  "emmet_language_server",
  "volar",
}
vim.lsp.enable(servers)
