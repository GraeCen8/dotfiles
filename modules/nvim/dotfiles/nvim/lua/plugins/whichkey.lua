-- Which-Key
local add = require("plugins.add")
add "folke/which-key.nvim"
require('which-key').setup({ preset = "helix" })
require("which-key").add({
  { "g",        group = "goto" },
  { "z",        group = "view" },
  { "<leader>", group = "leader" },
  { "<C-w>",    group = "windows" },
})
