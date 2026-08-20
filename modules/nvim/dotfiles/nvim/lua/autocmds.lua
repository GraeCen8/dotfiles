-- Run plugin build hooks on PackChanged
dofile(vim.fn.stdpath("config") .. "/lua/plugins/add.lua")

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
