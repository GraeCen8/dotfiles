-- custom plguins manager i made. it uses vim.pack under the hood and
-- has build script callback support 
-- examepe
--[[ ```lua
				add("folke/which-key.nvim")
``` --]] 



_G.plugin_build_callbacks = _G.plugin_build_callbacks or {}

local add = function(plug, opts)
  vim.pack.add({ { src = "https://github.com/" .. plug }, })
  if opts and opts.build and type(opts.build) == "function" then
    _G.plugin_build_callbacks[plug] = opts.build
  end
  return true
end

vim.api.nvim_create_autocmd("User", {
  pattern = "PackChanged",
  callback = function(args)
    local plug_name = args.data and args.data.name
    if plug_name and _G.plugin_build_callbacks and _G.plugin_build_callbacks[plug_name] then
      vim.notify("Running build for: " .. plug_name)
      pcall(_G.plugin_build_callbacks[plug_name])
    end
  end,
})

return add
