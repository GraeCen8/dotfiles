-- Plugin add helper with build hook registry
_G.plugin_build_callbacks = _G.plugin_build_callbacks or {}

function add(plug, opts)
  vim.pack.add({ { src = "https://github.com/" .. plug }, })
  if opts and opts.build and type(opts.build) == "function" then
    _G.plugin_build_callbacks[plug] = opts.build
  end
end
