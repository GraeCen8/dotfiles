local add = require('plugins')

add 'zbirenbaum/copilot.lua'

require("copilot").setup({
	suggestion = {
		enabled = true,
		auto_trigger = true,

		keymap = {
			accept = "<Tab>",
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
map('n', '<leader>c', "<Cmd>Copilot Toggle<Cr>", { desc = "Toggle Copilot" })
