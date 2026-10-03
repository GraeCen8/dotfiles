local languages = { "lua",
	"vim",
	"vimdoc",
	"bash",
	"json",
	"python",
	"javascript",
	"typescript",
}

local servers = { "lua_ls",
		"rust-analyzer"
}

local vim = vim
local map = vim.keymap.set
local o = vim.o

local add = function(pkg)
	vim.pack.add({ { src = "https://github.com/" .. pkg } })
end

o.number = true
o.wrap = false
o.tabstop = 4
o.swapfile = false
vim.o.laststatus = 3
vim.o.cmdheight = 0
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.signcolumn = "auto"
vim.g.mapleader = " "


map('n', "<leader>lf", vim.lsp.buf.format, { desc = "format" })
map('n', '<leader>x', ":write<CR>", { desc = "write" })
map('n', '<leader>w', "<C-w>", { remap = true, desc = "Window" })
map('n', ';', ':')

-- theming
add 'rebelot/kanagawa.nvim'
add 'vague2k/vague.nvim'
vim.cmd("colorscheme vague")
-- vim.cmd("colorscheme kanagawa")
vim.cmd(":hi statusline guibg=NONE")

-- oil explorer
add 'stevearc/oil.nvim'
require("oil").setup()
map("n", "-", "<CMD>Oil<CR>", { desc = "Oil" })

-- file picking
add 'nvim-mini/mini.pick'
add 'nvim-mini/mini.extra'
require("mini.pick").setup()
require("mini.extra").setup()
map("n", "<leader>f", ":Pick files<CR>")
map("n", "<leader>/", ":Pick grep_live<CR>")
map("n", "<leader>b", ":Pick buffers<CR>")
map("n", "<leader>'", ":Pick resume<CR>")
map("n", "<leader>e", ":Pick explorer<CR>")
map("n", "<leader>d", ":Pick diagnostic<CR>")

-- tree sitter
add "https://github.com/nvim-treesitter/nvim-treesitter"
require("nvim-treesitter").install(languages)

vim.api.nvim_create_autocmd("FileType", {
	callback = function(args)
		pcall(vim.treesitter.start, args.buf)
	end,
})

-- autopairs
add 'nvim-mini/mini.pairs'
require("mini.pairs").setup()

-- LSP
add 'neovim/nvim-lspconfig'
add 'saghen/blink.cmp'
add 'L3MON4D3/LuaSnip'
add 'rafamadriz/friendly-snippets'

require('luasnip.loaders.from_vscode').lazy_load()

require('blink.cmp').setup({
	keymap = { preset = "super-tab" },
	completion = { documentation = { auto_show = true }, },
})

vim.diagnostic.config({
	virtual_text = true,
	signs = true,
	underline = true,
	update_in_insert = true,
	serverity_sort = true,
	float = { border = "rounded", }
})

vim.lsp.enable(servers)

-- markdown LSP: wikilink completion, backlinks, inlay hints. Replaces marksman
local caps = vim.lsp.protocol.make_client_capabilities()
caps.workspace.didChangeWatchedFiles.dynamicRegistration = true
vim.lsp.config("markdown_oxide", {
	capabilities = caps,
	workspace = { didChangeWatchedFiles = { dynamicRegistration = true } },
})
vim.lsp.enable("markdown_oxide")

vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(ev)
		local buf = { buffer = ev.buf, silent = true }
		vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "LSP: Definition" })
		vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { desc = "LSP: Declaration" })
		vim.keymap.set("n", "gr", vim.lsp.buf.references, { desc = "LSP: References" })
		vim.keymap.set("n", "<leader>k", vim.lsp.buf.hover, { desc = "LSP: Hover" })
		vim.keymap.set("n", "<leader>r", vim.lsp.buf.rename, { desc = "LSP: Rename" })
		vim.keymap.set("n", "<leader>c", vim.lsp.buf.code_action, { desc = "LSP: Code Action" })
		vim.keymap.set("n", "<leader>F", vim.lsp.buf.format, { desc = "LSP: Format" })
	end,
})

-- statusline
add "https://github.com/nvim-lualine/lualine.nvim"

require("lualine").setup({
	options = {
		theme = "moonfly",
		globalstatus = true,
		component_separators = "",
		section_separators = "",
	},
	sections = {
		lualine_a = { "mode" },
		lualine_b = {},
		lualine_c = { "filename" },
		lualine_x = {},
		lualine_y = { "diagnostics" },
		lualine_z = { "location" },
	},
})

-- markdown viewer
add 'markup5/render-markdown.nvim'
require("render-markdown").setup({
	heading = { sign = "»" },
	-- indent wrapped continuation lines under the text, reads cleaner
	paragraph = { left_margin = 2, right_margin = 2 },
	quote = { left_margin = 2 },
})

map("n", "<leader>mt", "<CMD>RenderMarkdown set true<CR>", { desc = "Toggle markdown render" })
map("n", "<leader>mo", "<CMD>RenderMarkdown set false<CR>", { desc = "Markdown render off" })

vim.api.nvim_create_autocmd("FileType", {
	pattern = "markdown",
	callback = function(args)
		vim.opt_local.wrap = true
		vim.opt_local.linebreak = true
		vim.opt_local.cursorline = true
		vim.opt_local.spell = false
		vim.opt_local.conceallevel = 3
		pcall(vim.treesitter.start, args.buf)
	end,
})

-- which-key
add 'folke/which-key.nvim'
require("which-key").setup({
	delay = 0,

	preset = "helix",

	win = {
		padding = { 0, 1 },
	},

	layout = {
		spacing = 3,
	},
})

