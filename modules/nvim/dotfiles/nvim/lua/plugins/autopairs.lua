-- Auto pairs & autotag
local function add(plug)
  vim.pack.add({ { src = "https://github.com/" .. plug }, })
end
add 'windwp/nvim-autopairs'
add 'windwp/nvim-ts-autotag'
require('nvim-autopairs').setup { check_ts = true }
require('nvim-ts-autotag').setup()
