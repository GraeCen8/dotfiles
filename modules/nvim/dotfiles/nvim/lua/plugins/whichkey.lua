-- Which-Key
local function add(plug)
  vim.pack.add({ { src = "https://github.com/" .. plug }, })
end
add "folke/which-key.nvim"
require('which-key').setup({ preset = "helix" })
require("which-key").add({
  { "g",        group = "goto" },
  { "z",        group = "view" },
  { "<leader>", group = "leader" },
  { "<C-w>",    group = "windows" },
})
