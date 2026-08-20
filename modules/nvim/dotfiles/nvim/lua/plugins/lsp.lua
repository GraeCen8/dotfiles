-- LSP setup and related plugins
local servers = { "lua_ls", "ts_ls", "gopls", "pyright", "rust_analyzer", "ols", "zls", "zk", "marksman" }

local function add(plug)
  vim.pack.add({ { src = "https://github.com/" .. plug }, })
end

add "neovim/nvim-lspconfig"
add "mason-org/mason.nvim"
add "mason-org/mason-lspconfig.nvim"
add "saghen/blink.lib"
add "saghen/blink.cmp"

require("mason").setup()
require("mason-lspconfig").setup({ ensure_installed = servers })

require("blink.cmp").setup({
  keymap = { preset = "default", ["<CR>"] = { "accept", "fallback" }, },
  completion = {
    documentation = {
      auto_show = true,
      auto_show_delay_ms = 100,
    }
  },
  signature = { enabled = true },
  sources = { default = { "lsp", "path", "snippets", "buffer" } }
})
local capabilities = require("blink.cmp").get_lsp_capabilities()
vim.lsp.config("*", {
  capabilities = capabilities,
})

vim.diagnostic.config({
  virtual_text = true,
  signs = true,
  underline = true,
  severity_sort = true,
})

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local buf = args.buf
    local map = vim.keymap.set
    local lspmap = function(keys, fn, desc)
      map("n", keys, fn, {
        buffer = buf,
        desc = "LSP: " .. desc,
      })
    end
    lspmap("K", vim.lsp.buf.hover, "Hover")
    lspmap("gd", vim.lsp.buf.definition, "Definition")
    lspmap("gD", vim.lsp.buf.declaration, "Declaration")
    lspmap("gi", vim.lsp.buf.implementation, "Implementation")
    lspmap("gr", vim.lsp.buf.references, "References")
    lspmap("<leader>r", vim.lsp.buf.rename, "Rename")
    lspmap("<leader>a", vim.lsp.buf.code_action, "Code action")
    lspmap("<leader>F", vim.lsp.buf.format, "Format")
    lspmap("<leader>H", function()
      vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
    end, "inlay hints")
    --[[
    vim.api.nvim_create_autocmd("BufWritePre", {
      buffer = args.buf,
      callback = function()
        vim.lsp.buf.format({})
      end
    })
    --]]
  end,
})

vim.lsp.enable(servers)
