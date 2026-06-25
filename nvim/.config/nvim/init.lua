-- options
vim.g.mapleader = " "
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

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
o.timeoutlen = 300
o.splitbelow = true

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
	{ src = "https://github.com/nvim-telescope/telescope.nvim" },
	{ src = "https://github.com/nvim-lua/plenary.nvim" },
	{ src = "https://github.com/nvim-tree/nvim-tree.lua" },
	{ src = "https://github.com/folke/which-key.nvim" },
	{ src = "https://github.com/akinsho/toggleterm.nvim" },
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
	"telescope.nvim",
	"plenary.nvim",
	"nvim-tree.lua",
	"which-key.nvim",
	"toggleterm.nvim",
}) do
	packadd(plugin)
end

vim.cmd.colorscheme("moonfly")

-- mini.nvim
require("mini.pairs").setup()
require("mini.comment").setup()
require("mini.surround").setup()
require("mini.icons").setup()
MiniIcons.mock_nvim_web_devicons()
require("mini.indentscope").setup()
require("mini.statusline").setup()

local which_key = require("which-key")
which_key.setup({})
which_key.add({
	{ "<leader>s", group = "Search" },
	{ "<leader>l", group = "LSP" },
	{ "<leader>m", group = "Mini" },
	{ "<leader>f", group = "Format" },
	{ "<leader>t", group = "Terminal" },
})

-- telescope / explorer
require("telescope").setup({
	defaults = {
		mappings = {
			i = { ["<C-q>"] = require("telescope.actions").smart_send_to_qflist },
		},
	},
})

require("nvim-tree").setup({
	sync_root_with_cwd = true,
	update_focused_file = { enable = true, update_root = true },
	view = { width = 35 },
})

require("toggleterm").setup({})

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
local tb = require("telescope.builtin")
local Terminal = require("toggleterm.terminal").Terminal

map("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

local lazygit = Terminal:new({ cmd = "lazygit", direction = "float", hidden = true })
local floatterm = Terminal:new({ direction = "float", hidden = true })
local hterm = Terminal:new({ direction = "horizontal", hidden = true })

map("n", "<leader>e", "<cmd>NvimTreeToggle<cr>", { desc = "Explorer" })
map("n", "<leader>sf", tb.find_files, { desc = "Files" })
map("n", "<leader>sF", function()
	if not pcall(tb.git_files, { show_untracked = true }) then
		tb.find_files()
	end
end, { desc = "Git files" })
map("n", "<leader>sg", tb.live_grep, { desc = "Live grep" })
map("n", "<leader>sb", tb.buffers, { desc = "Buffers" })
map("n", "<leader>sr", tb.oldfiles, { desc = "Recent files" })
map("n", "<leader>sh", tb.help_tags, { desc = "Help tags" })
map("n", "<leader>sk", tb.keymaps, { desc = "Keymaps" })
map("n", "<leader>sd", tb.diagnostics, { desc = "Diagnostics" })
map("n", "<leader>ss", tb.lsp_document_symbols, { desc = "Symbols" })
map("n", "<leader>sS", tb.lsp_dynamic_workspace_symbols, { desc = "Workspace symbols" })
map("n", "<leader>sm", tb.man_pages, { desc = "C man pages" })
map("n", "<leader>sw", tb.grep_string, { desc = "Grep word" })
map("n", "<leader>sc", tb.git_status, { desc = "Git status" })
map("n", "<leader>tg", function() lazygit:toggle() end, { desc = "Lazygit" })
map("n", "<leader>tf", function() floatterm:toggle() end, { desc = "Float terminal" })
map("n", "<leader>th", function() hterm:toggle() end, { desc = "Horizontal terminal" })

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
