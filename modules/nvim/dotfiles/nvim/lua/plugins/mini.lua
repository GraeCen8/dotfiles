-- Mini icons & surround
local function add(plug)
  vim.pack.add({ { src = "https://github.com/" .. plug }, })
end
add 'echasnovski/mini.icons'
require('mini.icons').setup()
add 'echasnovski/mini.surround'
require('mini.surround').setup()
