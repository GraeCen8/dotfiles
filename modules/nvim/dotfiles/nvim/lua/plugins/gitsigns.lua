-- Gitsigns
local function add(plug)
  vim.pack.add({ { src = "https://github.com/" .. plug }, })
end
add 'lewis6991/gitsigns.nvim'
require('gitsigns').setup()
