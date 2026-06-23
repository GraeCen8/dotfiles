-- options
vim.g.mapleader = " "

local o = vim.opt
o.number = true
o.relativenumber = true
o.expandtab = true
o.shiftwidth = 4
o.smartindent = true
o.termguicolors = true
o.ignorecase = true
o.smartcase = true
o.winborder = "rounded"

-- packages
vim.pack.add({
	{ src = "https://github.com/echasnovski/mini.nvim" },
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter" },
	{ src = "https://github.com/saghen/blink.lib" },
	{ src = "https://github.com/lewis6991/gitsigns.nvim" },
	{ src = "https://github.com/saghen/blink.cmp" },
	{ src = "https://github.com/neovim/nvim-lspconfig" },
	{ src = "https://github.com/mason-org/mason.nvim" },
	{ src = "https://github.com/mason-org/mason-lspconfig.nvim" },
	{ src = "https://github.com/stevearc/conform.nvim" },
	{ src = "https://github.com/bluz71/vim-moonfly-colors" },
})

local function packadd(name)
	pcall(vim.cmd, "packadd " .. name)
end

for _, plugin in ipairs({
	"mini.nvim",
	"nvim-treesitter",
	"blink.lib",
	"gitsigns.nvim",
	"blink.cmp",
	"nvim-lspconfig",
	"mason.nvim",
	"mason-lspconfig.nvim",
	"conform.nvim",
	"vim-moonfly-colors",
}) do
	packadd(plugin)
end

vim.cmd.colorscheme("moonfly")

-- mini.nvim
require("mini.pairs").setup()
require("mini.comment").setup()
require("mini.surround").setup()
require("mini.icons").setup()
require("mini.files").setup()
require("mini.pick").setup()
require("mini.indentscope").setup()
require("mini.statusline").setup()

local miniclue = require("mini.clue")
miniclue.setup({
	triggers = {
		{ mode = { "n", "x" }, keys = "<Leader>" },
		{ mode = { "n", "x" }, keys = "g" },
		{ mode = "n", keys = "[" },
		{ mode = "n", keys = "]" },
		{ mode = "n", keys = "<C-w>" },
		{ mode = "i", keys = "<C-x>" },
		{ mode = { "n", "x" }, keys = '"' },
		{ mode = { "n", "x" }, keys = "'" },
		{ mode = { "n", "x" }, keys = "`" },
		{ mode = { "n", "x" }, keys = "z" },
	},
	clues = {
		{ mode = "n", keys = "<Leader>f", desc = "+Find" },
		{ mode = "n", keys = "<Leader>l", desc = "+LSP" },
		{ mode = "n", keys = "<Leader>m", desc = "+Mini" },
		miniclue.gen_clues.square_brackets(),
		miniclue.gen_clues.builtin_completion(),
		miniclue.gen_clues.g(),
		miniclue.gen_clues.marks(),
		miniclue.gen_clues.registers(),
		miniclue.gen_clues.windows({
			submode_move = true,
			submode_navigate = true,
			submode_resize = true,
		}),
		miniclue.gen_clues.z(),
	},
})

-- other setup
require("gitsigns").setup()

local blink_cmp = require("blink.cmp")
if not blink_cmp.library_available() then
	pcall(function()
		blink_cmp.build():pwait()
	end)
end

blink_cmp.setup({
	fuzzy = {
		implementation = blink_cmp.library_available() and "rust" or "lua",
	},
})

local ok_conform, conform = pcall(require, "conform")
if ok_conform then
	conform.setup({
		format_on_save = {
			timeout_ms = 500,
			lsp_format = "fallback",
		},
		formatters_by_ft = {
			lua = { "stylua" },
			bash = { "shfmt" },
			sh = { "shfmt" },
			python = { "ruff_format" },
			json = { "prettier" },
			markdown = { "prettier" },
		},
	})
end

-- language setup
require("nvim-treesitter.config").setup({
	highlight = { enable = true },
	indent = { enable = true },
})

require("mason").setup()

local servers = {
	"lua_ls",
	"pyright",
	"ts_ls",
	"gopls",
	"rust_analyzer",
	"bashls",
	"clangd",
}

require("mason-lspconfig").setup({
	ensure_installed = servers,
})

for _, s in ipairs(servers) do
	vim.lsp.enable(s)
end

if ok_conform then
	local map = vim.keymap.set
	map({ "n", "v" }, "<leader>fm", function()
		conform.format({ lsp_format = "fallback", async = true })
	end, { desc = "Format buffer" })

	vim.api.nvim_create_autocmd("BufWritePre", {
		callback = function(ev)
			conform.format({ bufnr = ev.buf, lsp_format = "fallback", timeout_ms = 500 })
		end,
	})
end

-- keybinds
local map = vim.keymap.set

map("n", "<leader>e", function()
	require("mini.files").open()
end, { desc = "Explorer" })

map("n", "<leader>ff", function()
	require("mini.pick").builtin.files()
end, { desc = "Find files" })

map("n", "<leader>fg", function()
	require("mini.pick").builtin.grep_live()
end, { desc = "Live grep" })

vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(ev)
		local opts = { buffer = ev.buf }
		map("n", "gd", vim.lsp.buf.definition, opts)
		map("n", "gr", vim.lsp.buf.references, opts)
		map("n", "K", vim.lsp.buf.hover, opts)
		map("n", "<leader>rn", vim.lsp.buf.rename, opts)
		map("n", "<leader>ca", vim.lsp.buf.code_action, opts)
	end,
})

-- core remaps
map({ "n", "v" }, ";", ":")
