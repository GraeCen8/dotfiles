_G.plugin_build_callbacks = _G.plugin_build_callbacks or {}

local add = function(plug, opts)
	vim.pack.add({
		{
			src = "https://github.com/" .. plug,
		},
	})

	if opts and opts.build and type(opts.build) == "function" then
		_G.plugin_build_callbacks[plug] = opts.build
	end

	return true
end

vim.api.nvim_create_autocmd("PackChanged", {
	callback = function(args)
		local data = args.data

		if not data or not data.name then
			return
		end

		local callback = _G.plugin_build_callbacks[data.name]

		if callback then
			vim.notify("Running build for: " .. data.name)

			local ok, err = pcall(callback)

			if not ok then
				vim.notify(
					"Build failed for " .. data.name .. ": " .. tostring(err),
					vim.log.levels.ERROR
				)
			end
		end
	end,
})

return add
