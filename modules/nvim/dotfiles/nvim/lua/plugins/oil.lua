-- Oil.nvim
local function add(plug)
  vim.pack.add({ { src = "https://github.com/" .. plug }, })
end
add "stevearc/oil.nvim"
require "oil".setup()
