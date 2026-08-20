-- Load options, keymaps, and theme
require("options")
require("keymaps")
require("theme")
require("autocmds")

-- Globally require every file in lua/plugins/
local plugins_dir = vim.fn.stdpath('config') .. '/lua/plugins'
local handle = vim.loop.fs_scandir(plugins_dir)
if handle then
  while true do
    local name, t = vim.loop.fs_scandir_next(handle)
    if not name then break end
    if t == 'file' and name:match('%.lua$') then
      local mod = 'plugins.' .. name:gsub('%.lua$', '')
      require(mod)
    end
  end
end
