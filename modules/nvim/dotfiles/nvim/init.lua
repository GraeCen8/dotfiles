local vim = vim

local servers = { "lua_ls", "ts_ls", "gopls", "pyright",
	"rust_analyzer", "ols", "zls", "zk", "marksman" }

local langs = { "rust", "javascript", "typescript", "go",
	"c", "cpp", "odin", "zig", "lua", "markdown", "markdown_inline" }

-- vim opts
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
o.winborder = "none"
o.clipboard = "unnamedplus"
vim.highlight.on_yank()

-- vim main keybind mappings
local map = vim.keymap.set
vim.g.mapleader = " "
map({ "n", "v", "x" }, ";", ":")
map('i', "jk", "<Esc>")
map('n', '<leader>w', '<C-w>', { desc = "Windows" })

for _, key in ipairs({ "h", "j", "k", "l" }) do
	map({ "n", "v", "x" }, "<C-" .. key .. ">", "<C-w>" .. key)
end

for _, key in ipairs({ "j", "k" }) do
	local dir = key == "j" and "+1" or "-2"
	map('n', '<A-' .. key .. '>', ':m .' .. dir .. '<CR>==')
	map('i', '<A-' .. key .. '>', '<Esc>:m .' .. dir .. '<CR>==gi')
end

map({ "n", "v", "x" }, "<leader>B", function()
	require("blink.cmp").build():pwait()
end, { desc = "Build" })

map("n", "]b", ":bnext<CR>", { desc = "Next buffer" })
map("n", "[b", ":bprevious<CR>", { desc = "Previous buffer" })
map("n", "<leader>x", ":bdelete<CR>", { desc = "Close buffer" })
map("n", "<leader>-", "<C-w>s", { desc = "Horizontal split" })
map("n", "<leader>=", "<C-w>v", { desc = "Vertical split" })

-- plugin syntax
local function add(plug)
	vim.pack.add({ { src = "https://github.com/" .. plug }, })
end

-- Omarchy theme: read colors.toml and apply dynamically
local function load_omarchy_theme()
	local colors_path = vim.fn.expand("~/.local/state/omarchy/current/theme/colors.toml")
	local f = io.open(colors_path, "r")
	if not f then return nil end
	local c = {}
	for line in f:lines() do
		local key, val = line:match('^([%w_]+)%s*=%s*"(#[%x]+)"')
		if key and val then c[key] = val end
	end
	f:close()
	return c
end

local c = load_omarchy_theme()
if c then
	vim.api.nvim_set_hl(0, "Normal", { fg = c.foreground, bg = c.background })
	vim.api.nvim_set_hl(0, "Comment", { fg = c.muted, italic = true })
	vim.api.nvim_set_hl(0, "Constant", { fg = c.yellow })
	vim.api.nvim_set_hl(0, "String", { fg = c.green })
	vim.api.nvim_set_hl(0, "Identifier", { fg = c.blue })
	vim.api.nvim_set_hl(0, "Function", { fg = c.blue })
	vim.api.nvim_set_hl(0, "Statement", { fg = c.magenta })
	vim.api.nvim_set_hl(0, "PreProc", { fg = c.magenta })
	vim.api.nvim_set_hl(0, "Type", { fg = c.yellow })
	vim.api.nvim_set_hl(0, "Special", { fg = c.orange })
	vim.api.nvim_set_hl(0, "Error", { fg = c.red })
	vim.api.nvim_set_hl(0, "Todo", { fg = c.accent, bold = true })
	vim.api.nvim_set_hl(0, "Search", { fg = c.background, bg = c.accent })
	vim.api.nvim_set_hl(0, "Visual", { bg = c.selection })
	vim.api.nvim_set_hl(0, "CursorLine", { bg = c.lighter_background })
	vim.api.nvim_set_hl(0, "LineNr", { fg = c.muted })
	vim.api.nvim_set_hl(0, "CursorLineNr", { fg = c.foreground, bold = true })
	vim.api.nvim_set_hl(0, "StatusLine", { fg = c.background, bg = c.accent, bold = true })
	vim.api.nvim_set_hl(0, "Pmenu", { fg = c.foreground, bg = c.lighter_background })
	vim.api.nvim_set_hl(0, "PmenuSel", { fg = c.background, bg = c.accent })
	vim.api.nvim_set_hl(0, "TabLine", { fg = c.muted, bg = c.background })
	vim.api.nvim_set_hl(0, "TabLineFill", { bg = c.background })
	vim.api.nvim_set_hl(0, "TabLineSel", { fg = c.foreground, bg = c.background, bold = true })
	vim.api.nvim_set_hl(0, "DiagnosticError", { fg = c.red })
	vim.api.nvim_set_hl(0, "DiagnosticWarn", { fg = c.yellow })
	vim.api.nvim_set_hl(0, "DiagnosticInfo", { fg = c.blue })
	vim.api.nvim_set_hl(0, "DiagnosticHint", { fg = c.cyan })
	vim.api.nvim_set_hl(0, "DiffAdd", { fg = c.green })
	vim.api.nvim_set_hl(0, "DiffDelete", { fg = c.muted })
	vim.api.nvim_set_hl(0, "DiffChange", { fg = c.yellow })
	vim.api.nvim_set_hl(0, "MatchParen", { bg = c.selection, bold = true })
else
	vim.cmd("colorscheme desert")
end


-- Oil.nvim
add "stevearc/oil.nvim"
require "oil".setup()

map("n", "-", "<Cmd>Oil<CR>", { desc = "Open parent directory" })

-- Snacks picker keybinds
local pickers = {
	{ "<leader>f",        "files",                 "Find files" },
	{ "<leader><leader>", "files",                 "Find Files" },
	{ "<leader>/",        "grep",                  "Grep" },
	{ "<leader>,",        "buffers",               "Buffers" },
	{ "<leader>g",        "git_files",             "Git files" },
	{ "<leader>T",        "colorschemes",          "Themes" },
	{ "<leader>s",        "lsp_symbols",           "LSP symbols" },
	{ "<leader>S",        "lsp_workspace_symbols", "LSP workspace symbols" },
	{ "<leader>d",        "diagnostics",           "Diagnostics" },
	{ "<leader>m",        "man",                   "Man Pages" },
}

for _, p in ipairs(pickers) do
	map("n", p[1], function() Snacks.picker[p[2]]() end, { desc = p[3] })
end

map("n", "<C-/>", function() Snacks.terminal() end, { desc = "Terminal" })
map("n", "<leader>e", function() Snacks.explorer() end, { desc = "Files" })
map("n", "<leader>l", function() Snacks.lazygit() end, { desc = "Lazygit" })

-- LSP setup
add "neovim/nvim-lspconfig"
add "mason-org/mason.nvim"
add "mason-org/mason-lspconfig.nvim"
add "saghen/blink.lib"
add "saghen/blink.cmp"

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

		-- vim.api.nvim_create_autocmd("BufWritePre", {
		-- 	buffer = args.buf,
		-- 	callback = function()
		-- 		vim.lsp.buf.format({})
		-- 	end
		-- })
	end,
})

vim.lsp.enable(servers)

-- Which Key
add "folke/which-key.nvim"
require('which-key').setup({ preset = "helix" })
require("which-key").add({
	{ "g",        group = "goto" },
	{ "z",        group = "view" },
	{ "<leader>", group = "leader" },
	{ "<C-w>",    group = "windows" },
})

-- Tree Sitter
add 'nvim-treesitter/nvim-treesitter'
add 'nvim-treesitter/nvim-treesitter-textobjects'
require('nvim-treesitter').setup({
	ensure_installed = langs,
	highlight = {
		enable = true,
	},
	indent = {
		enable = true,
	},
	textobjects = {
		select = {
			enable = true,
			lookahead = true,
			keymaps = {
				["af"] = "@function.outer",
				["if"] = "@function.inner",
				["ac"] = "@class.outer",
				["ic"] = "@class.inner",
			},
		},
		move = {
			enable = true,
			set_jumps = true,
			goto_next_start = {
				["]f"] = "@function.outer",
				["]c"] = "@class.outer",
			},
			goto_previous_start = {
				["[f"] = "@function.outer",
				["[c"] = "@class.outer",
			},
		},
	},
})

-- Auto pairs
add 'windwp/nvim-autopairs'
add 'windwp/nvim-ts-autotag'

require('nvim-autopairs').setup { check_ts = true }
require('nvim-ts-autotag').setup()

-- Highlight yanked text
vim.api.nvim_create_autocmd("TextYankPost", {
	callback = function()
		vim.highlight.on_yank({
			higroup = "IncSearch",
			timeout = 300,
		})
	end,
})
-- Esc clears search highlight
map("n", "<Esc>", "<cmd>nohlsearch<CR><Esc>", {
	silent = true,
})
map("t", "<Esc><Esc>", "<C-\\><C-n>", { silent = true })

-- Mini icons
add 'echasnovski/mini.icons'
require('mini.icons').setup()

-- Gitsigns
add 'lewis6991/gitsigns.nvim'
require('gitsigns').setup()

-- Mini surround
add 'echasnovski/mini.surround'
require('mini.surround').setup()

-- Flash (jump)
add 'folke/flash.nvim'
require('flash').setup()
map({ "n", "x", "v" }, "s", function() require("flash").jump() end, { desc = "Flash" })

-- Status line
add 'nvim-lualine/lualine.nvim'
local function lualine_theme()
	if not c then return "auto" end
	return {
		normal = {
			a = { fg = c.background, bg = c.accent, bold = true },
			b = { fg = c.foreground, bg = c.lighter_background },
			c = { fg = c.foreground, bg = c.background },
		},
		insert = {
			a = { fg = c.background, bg = c.green, bold = true },
		},
		visual = {
			a = { fg = c.background, bg = c.magenta, bold = true },
		},
		replace = {
			a = { fg = c.background, bg = c.red, bold = true },
		},
		command = {
			a = { fg = c.background, bg = c.yellow, bold = true },
		},
		inactive = {
			a = { fg = c.muted, bg = c.background },
			b = { fg = c.muted, bg = c.background },
			c = { fg = c.muted, bg = c.background },
		},
	}
end
require("lualine").setup({
	options = {
		theme = lualine_theme(),
		component_separators = "",
		section_separators = { left = "", right = "" },
		globalstatus = true,
	},
	sections = {
		lualine_a = { "mode" },
		lualine_b = {
			{ "branch", icon = "" },
			{ "diff", symbols = { added = "+", modified = "~", removed = "-" } },
		},
		lualine_c = { "filename" },
		lualine_x = { "filetype" },
		lualine_y = {},
		lualine_z = { "location" },
	},
})

-- Snacks.nvim
add 'folke/snacks.nvim'

require 'snacks'.setup({
	picker = { enabled = true },
	explorer = { enabled = true },
	dashboard = { enabled = true },
	image = { enabled = true },
})

-- markdown
add "MeanderingProgrammer/render-markdown.nvim"
require("render-markdown").setup({
	code = { sign = false, width = "block", right_pad = 1 },
	heading = { sign = false, icons = {} },
	checkbox = { enabled = false },
})
map("n", "<leader>M", function() require("render-markdown").toggle() end, { desc = "Render Markdown" })

