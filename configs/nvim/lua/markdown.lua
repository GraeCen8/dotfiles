local add = require('plugins')

add "MeanderingProgrammer/render-markdown.nvim"
require('render-markdown').setup({
	code = { sign = false, width = "block", right_pad = 1 },
	heading = { sign = false, icons = {} },
	checkbox = { enabled = false },
})

-- toggle markdown rendering
local map = vim.keymap.set
map("n", "<leader>M", "<Cmd>RenderMarkdown toggle<Cr>", { desc = "toggle markdown" })
