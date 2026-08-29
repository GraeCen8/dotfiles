local add = require('plugins')
local vim = vim
local langs = { "lua", "rust", "c", "cpp", "odin", "go", "python", "toml", "zig", "fish" }

add 'nvim-treesitter/nvim-treesitter'
add 'nvim-treesitter/nvim-treesitter-textobjects'

local group = vim.api.nvim_create_augroup("GraeTreesitter", { clear = true })
vim.api.nvim_create_autocmd({ "BufEnter", "FileType" }, {
	group = group,
	callback = function()
		if vim.bo.buftype ~= "" then
			return
		end

		pcall(vim.treesitter.start, 0)
	end,
})

vim.api.nvim_create_autocmd("User", {
	group = group,
	pattern = "VeryLazy",
	once = true,
	callback = function()
		require("nvim-treesitter").install(langs)
	end,
})

require("nvim-treesitter-textobjects").setup({
	select = {
		enable = true,
		lookahead = true,
		keymaps = {
			["af"] = "@function.outer",
			["if"] = "@function.inner",
		},
	},
})

