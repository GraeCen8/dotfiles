-- Plugin helper
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

local map = vim.keymap.set

--
-- Remap
--
vim.g.mapleader = " "

map("n", "<leader>w", "<C-w>")
map("i", "jk", "<Esc>")
map("n", ";", ":")

map("n", "]b", ":bnext<CR>", { desc = "Next buffer" })
map("n", "[b", ":bprevious<CR>", { desc = "Previous buffer" })
map("n", "<leader>x", ":bdelete<CR>", { desc = "Close buffer" })
map("n", "<leader>-", "<C-w>s", { desc = "Horizontal split" })
map("n", "<leader>=", "<C-w>v", { desc = "Vertical split" })

map("n", "<Esc>", "<cmd>nohlsearch<CR><Esc>", {
	silent = true,
})

map("t", "<Esc><Esc>", "<C-\\><C-n>", { silent = true })

for _, key in ipairs({ "h", "j", "k", "l" }) do
	map({ "n", "v", "x" }, "<C-" .. key .. ">", "<C-w>" .. key)
end

map({ 'n', 'v' }, '<leader>y', '"+y')
map({ 'n', 'v' }, '<leader>p', '"+p')

map({ 'n', 'v' }, '<leader>t', "<leader>-<C-w>j:term<Cr>a", { desc = "open terminal", remap = true })

--
-- Options
--
local o = vim.o
o.number = true
o.relativenumber = true
o.tabstop = 2
o.softtabstop = 2
o.signcolumn = "yes"
o.undofile = true
o.autoread = true
o.laststatus = 3
o.cmdheight = 0
o.winborder = "rounded"
o.clipboard = "unnamedplus"
o.scrolloff = 8

vim.highlight.on_yank()

--
-- Colors
--
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
		theme = 'rose-pine',
		component_separators = { left = '·', right = '·' },
		section_separators = { left = '', right = '' },
		globalstatus = true,
	},
	sections = {
		lualine_a = {},
		lualine_b = { 'branch', 'diff' },
		lualine_c = { { 'filename', path = 1 } },
		lualine_x = { 'diagnostics' },
		lualine_y = { 'progress' },
		lualine_z = { 'location' }
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

--
-- Treesitter
--
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

--
-- LSP
--
local servers = { "lua_ls", "ts_ls", "gopls", "pyright", "rust_analyzer", "ols", "zls", "zk", "taplo", "marksman" }

add("neovim/nvim-lspconfig")
add("mason-org/mason.nvim")
add("mason-org/mason-lspconfig.nvim")
add("saghen/blink.lib")
add("saghen/blink.cmp", {
	build = function()
		require("blink.cmp").build():pwait()
	end,
})

require("mason").setup()
require("mason-lspconfig").setup({ ensure_installed = servers })

require("blink.cmp").setup({
	keymap = { preset = "default", ["<CR>"] = { "accept", "fallback" }, },
	completion = {
		documentation = {
			auto_show = true,
			auto_show_delay_ms = 100,
		}
	},
	signature = { enabled = true },
	sources = { default = { "lsp", "path", "snippets", "buffer" } }
})
local capabilities = require("blink.cmp").get_lsp_capabilities()
vim.lsp.config("*", {
	capabilities = capabilities,
})

vim.diagnostic.config({
	virtual_text = true,
	signs = true,
	underline = true,
	severity_sort = true,
})

vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(args)
		local buf = args.buf
		local lspmap = function(keys, fn, desc)
			map("n", keys, fn, {
				buffer = buf,
				desc = "LSP: " .. desc,
			})
		end
		lspmap("K", vim.lsp.buf.hover, "Hover")
		lspmap("gd", vim.lsp.buf.definition, "Definition")
		lspmap("gD", vim.lsp.buf.declaration, "Declaration")
		lspmap("gi", vim.lsp.buf.implementation, "Implementation")
		lspmap("gr", vim.lsp.buf.references, "References")
		lspmap("<leader>r", vim.lsp.buf.rename, "Rename")
		lspmap("<leader>a", vim.lsp.buf.code_action, "Code action")
		lspmap("<leader>F", vim.lsp.buf.format, "Format")
		lspmap("<leader>H", function()
			vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
		end, "inlay hints")
	end,
})
vim.lsp.enable(servers)

--
-- Other plugins
--
vim.api.nvim_create_autocmd("VimLeavePre", {
	callback = function()
		vim.cmd("silent! wall")
	end,
})

add 'mbbill/undotree'
map("n", "<leader>u", vim.cmd.UndotreeToggle, { desc = "undo tree" })

add 'stevearc/oil.nvim'
require 'oil'.setup()
map("n", "-", "<Cmd>Oil<Cr>", { desc = "file tree" })

add 'lewis6991/gitsigns.nvim'
require('gitsigns').setup()

add 'folke/flash.nvim'
require('flash').setup()
map({ "n", "x", "v" }, "<C-s>", function() require("flash").jump() end, { desc = "Flash" })

add 'nvim-tree/nvim-web-devicons'

--
-- Markdown
--
add "MeanderingProgrammer/render-markdown.nvim"
require('render-markdown').setup({
	code = { sign = false, width = "block", right_pad = 1 },
	heading = { sign = false, icons = {} },
	checkbox = { enabled = false },
})
map("n", "<leader>M", "<Cmd>RenderMarkdown toggle<Cr>", { desc = "toggle markdown" })

--
-- Copilot
--
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

map('n', '<leader>A', "<Cmd>Copilot toggle<Cr>", { desc = "Toggle Copilot" })

--
-- Mini
--
add 'nvim-mini/mini.nvim'

require('mini.align').setup()
require('mini.move').setup()
require('mini.surround').setup()
require('mini.bracketed').setup()

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

local hipatterns = require('mini.hipatterns')
hipatterns.setup({
	highlighters = {
		todo = { pattern = '%f[%w]()TODO()%f[%W]', group = "MiniHipatternsTodo" },
		note = { pattern = '%f[%w]()NOTE()%f[%W]', group = "MiniHipatternsNote" },
		hex_color = hipatterns.gen_highlighter.hex_color(),
	}
})
require('mini.cursorword').setup()

require('mini.pairs').setup()
add 'windwp/nvim-ts-autotag'
require('nvim-ts-autotag').setup()

local miniclue = require('mini.clue')
miniclue.setup({
	triggers = {
		{ mode = { 'n', 'x' }, keys = '<leader>' },
		{ mode = { 'n', 'x' }, keys = 'g' },
		{ mode = { 'n', 'x' }, keys = 'z' },
		{ mode = 'n',          keys = '<C-w>' },
		{ mode = { 'n', 'x' }, keys = '[' },
		{ mode = { 'n', 'x' }, keys = ']' },
		{ mode = { 'n', 'x' }, keys = "'" },
		{ mode = { 'n', 'x' }, keys = '`' },
		{ mode = { 'i', 'c' }, keys = '<C-r>' },
		{ mode = 'n',          keys = '<C-x>' },
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
		delay = 200,
	},
})

vim.api.nvim_create_autocmd("BufEnter", {
	callback = function()
		MiniClue.ensure_buf_triggers()
	end,
})
