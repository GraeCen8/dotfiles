-- Treesitter setup
local langs = { "rust", "javascript", "typescript", "go", "c", "cpp", "odin", "zig", "lua", "markdown", "markdown_inline" }
local add = require("plugins.add")

add 'nvim-treesitter/nvim-treesitter'
add 'nvim-treesitter/nvim-treesitter-textobjects'
require('nvim-treesitter').setup({
  ensure_installed = langs,
  highlight = {
    enable = true,
  },
  indent = {
    enable = true,
  },
  textobjects = {
    select = {
      enable = true,
      lookahead = true,
      keymaps = {
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["ac"] = "@class.outer",
        ["ic"] = "@class.inner",
      },
    },
    move = {
      enable = true,
      set_jumps = true,
      goto_next_start = {
        ["]f"] = "@function.outer",
        ["]c"] = "@class.outer",
      },
      goto_previous_start = {
        ["[f"] = "@function.outer",
        ["[c"] = "@class.outer",
      },
    },
  },
})
