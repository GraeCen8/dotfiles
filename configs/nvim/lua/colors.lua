local add = require('plugins')

add 'rose-pine/neovim'

function ColorPencils(color)
	color = color or "rose-pine"
	vim.cmd('colorscheme ' .. color)

	vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
	vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
end

ColorPencils("rose-pine")

add 'nvim-lualine/lualine.nvim'
require('lualine').setup({
	options = {
		theme = 'rose-pine', -- 'nord' or 'none' gives a flat, text-only look
		component_separators = { left = '·', right = '·' },
		section_separators = { left = '', right = '' },
		globalstatus = true, -- Single statusline at the bottom of all windows
	},
	sections = {
		lualine_a = {},             -- Removes the large Vim Mode block (NORMAL/INSERT)
		lualine_b = { 'branch', 'diff' }, -- Shows git branch and minimal status
		lualine_c = { { 'filename', path = 1 } }, -- Shows file name with relative path
		lualine_x = { 'diagnostics' }, -- Shows LSP errors/warnings only
		lualine_y = { 'progress' }, -- Shows file percentage (e.g., 50%)
		lualine_z = { 'location' }  -- Shows line:column numbers
	},
	inactive_sections = {
		lualine_a = {},
		lualine_b = {},
		lualine_c = { 'filename' },
		lualine_x = { 'location' },
		lualine_y = {},
		lualine_z = {}
	},
})
