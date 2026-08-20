-- Snacks.nvim & related pickers/extras
local function add(plug)
  vim.pack.add({ { src = "https://github.com/" .. plug }, })
end
add 'folke/snacks.nvim'
require 'snacks'.setup({
  picker = { enabled = true },
  explorer = { enabled = true },
  dashboard = { enabled = true },
  image = { enabled = true },
})
