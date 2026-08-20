-- Snacks.nvim & related pickers/extras
local add = require("plugins.add")
add 'folke/snacks.nvim'
require 'snacks'.setup({
  picker = { enabled = true },
  explorer = { enabled = true },
  dashboard = { enabled = true },
  image = { enabled = true },
})
