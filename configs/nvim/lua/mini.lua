local add = require('plugins')
local map = vim.keymap.set

add 'nvim-mini/mini.nvim'

-- some just setup ones
require('mini.starter').setup()
require('mini.align').setup()
require('mini.move').setup()
require('mini.surround').setup()
require('mini.bracketed').setup()

-- picker setup
require('mini.pick').setup()
require('mini.extra').setup()
local pick = MiniPick
local extra = MiniExtra

map("n", "<leader>f", pick.builtin.files, { desc = "Find files" })
map("n", "<leader>/", pick.builtin.grep_live, { desc = "Live grep" })
map("n", "<leader>b", pick.builtin.buffers, { desc = "Find buffers" })
map("n", "<leader>g", extra.pickers.git_files, { desc = "Git files" })
map("n", "<leader>d", extra.pickers.diagnostic, { desc = "diagnostics" })
map('n', "<leader>e", extra.pickers.explorer, { desc = "explorer" })

map("n", "<leader>s", function()
	extra.pickers.lsp({ scope = "document_symbol" })
end, { desc = "Document symbols" })
map("n", "<leader>S", function()
	extra.pickers.lsp({ scope = "workspace_symbol" })
end, { desc = "Workspace symbols" })

map("n", "<leader>'", pick.builtin.resume, { desc = "Last picker" })

-- highlight
local hipatterns = require('mini.hipatterns')
hipatterns.setup({
	highlighters = {
		todo = { pattern = '%f[%w]()TODO()%f[%W]', group = "MiniHipatternsTodo" },
		note = { pattern = '%f[%w]()NOTE()%f[%W]', group = "MiniHipatternsNote" },
		hex_color = hipatterns.gen_highlighter.hex_color(),
	}
})
require('mini.cursorword').setup()

-- autopairs
require('mini.pairs').setup()
add 'windwp/nvim-ts-autotag'
require('nvim-ts-autotag').setup()

-- keybinding hints
local miniclue = require('mini.clue')
miniclue.setup({
	triggers = {
		{ mode = { 'n', 'x' }, keys = '<leader>' },
		{ mode = { 'n', 'x' }, keys = 'g' },
		{ mode = { 'n', 'x' }, keys = 'z' },
		{ mode = 'n', keys = '<C-w>' },
		{ mode = { 'n', 'x' }, keys = '[' },
		{ mode = { 'n', 'x' }, keys = ']' },
		{ mode = { 'n', 'x' }, keys = "'" },
		{ mode = { 'n', 'x' }, keys = '`' },
		{ mode = { 'i', 'c' }, keys = '<C-r>' },
		{ mode = 'n', keys = '<C-x>' },
	},
	clues = {
		miniclue.gen_clues.square_brackets(),
		miniclue.gen_clues.g(),
		miniclue.gen_clues.z(),
		miniclue.gen_clues.marks(),
		miniclue.gen_clues.registers(),
		miniclue.gen_clues.windows(),
		miniclue.gen_clues.builtin_completion(),
	},
	window = {
		config = { border = "rounded" },
		delay = 50,
	},
})

vim.api.nvim_create_autocmd("LspAttach", {
	callback = function()
		MiniClue.ensure_buf_triggers()
	end,
})

