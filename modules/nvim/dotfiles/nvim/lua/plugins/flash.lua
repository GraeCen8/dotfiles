-- Flash.nvim
local function add(plug)
  vim.pack.add({ { src = "https://github.com/" .. plug }, })
end
add 'folke/flash.nvim'
require('flash').setup()
