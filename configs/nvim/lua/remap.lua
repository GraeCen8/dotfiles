vim.g.mapleader = " "

local map = vim.keymap.set

map("n", "<leader>w", "<C-w>")
map("i", "jk", "<Esc>")
map("n", ";", ":")

map("n", "]b", ":bnext<CR>", { desc = "Next buffer" })
map("n", "[b", ":bprevious<CR>", { desc = "Previous buffer" })
map("n", "<leader>x", ":bdelete<CR>", { desc = "Close buffer" })
map("n", "<leader>-", "<C-w>s", { desc = "Horizontal split" })
map("n", "<leader>=", "<C-w>v", { desc = "Vertical split" })

-- Esc clears search highlight
map("n", "<Esc>", "<cmd>nohlsearch<CR><Esc>", {
	silent = true,
})

-- terminal esc
map("t", "<Esc><Esc>", "<C-\\><C-n>", { silent = true })

for _, key in ipairs({ "h", "j", "k", "l" }) do
	map({ "n", "v", "x" }, "<C-" .. key .. ">", "<C-w>" .. key)
end

for _, key in ipairs({ "j", "k" }) do
	local dir = key == "j" and "+1" or "-2"
	map('n', '<A-' .. key .. '>', ':m .' .. dir .. '<CR>==')
	map('i', '<A-' .. key .. '>', '<Esc>:m .' .. dir .. '<CR>==gi')
end

-- Yank to system clipboard
-- map({ 'n', 'v' }, '<leader>y', '"+y')
-- map({ 'n', 'v' }, '<leader>p', '"+p')

-- Terminal opening
map({'n', 'v'}, '<leader>t', "<leader>-<C-w>j:term<Cr>a", {desc = "open terminal", remap=true})

