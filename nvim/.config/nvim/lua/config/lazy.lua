local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
	vim.fn.mkdir(vim.fn.fnamemodify(lazypath, ":p:h"), "p")

	local clone_result = vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		lazypath,
	})

	if vim.v.shell_error ~= 0 then
		error("Failed to clone lazy.nvim:\n" .. clone_result)
	end
end

vim.opt.rtp:prepend(lazypath)

require("lazy").setup("plugins")

