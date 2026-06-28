local lsp_servers = {
    "lua_ls",
    "pyright",
    "ts_ls",
    "html-lsp",
    "css_lsp",
    "bashls",
    "gopls",
    "rust_analyzer",
    "templ",
}



local treesitter_languages = {
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
}

_G.NVIM_LSP_SERVERS = lsp_servers
_G.NVIM_TREESITTER_LANGUAGES = treesitter_languages

require("core.options")
require("core.keymaps")
require("config.lazy")

