local add = require('plugins')

add 'zbirenbaum/copilot.lua'

require("copilot").setup({
	suggestion = {
		enabled = false,
		auto_trigger = true,

		keymap = {
			accept = "<C-y>",
			next = "<C-e>",
			prev = "<C-r>",
			dismiss = "<C-=>",
		}
	},

	filetypes = {
		markdown = true,
		help = false,
	}
})

local map = vim.keymap.set
-- enable or disable copilot
map('n', '<leader>A', "<Cmd>Copilot toggle<Cr>", { desc = "Toggle Copilot" })
