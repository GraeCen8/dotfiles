-- Keymaps
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

-- Oil.nvim
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

-- Esc clears search highlight
map("n", "<Esc>", "<cmd>nohlsearch<CR><Esc>", {
	silent = true,
})
map("t", "<Esc><Esc>", "<C-\\><C-n>", { silent = true })

-- Flash (jump)
map({ "n", "x", "v" }, "s", function() require("flash").jump() end, { desc = "Flash" })
-- Markdown toggle
map("n", "<leader>M", function() require("render-markdown").toggle() end, { desc = "Render Markdown" })
