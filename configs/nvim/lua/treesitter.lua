local add = require('plugins')

add 'nvim-treesitter/nvim-treesitter'

require'nvim-treesitter'.setup {
	ensure_installed = { "lua", "rust", "c", "cpp", "odin", "go", "python"},
	auto_install = true,
	highlight = {
		enable = true,
		additional_vim_regex_highlighting = false,
	}
}
