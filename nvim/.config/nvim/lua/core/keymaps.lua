vim.g.mapleader = " "

local map = vim.keymap.set

map("n", "<Esc>", "<cmd>noh<CR>", { desc = "Clear search" })

-- Better window movement
map("n", "<C-h>", "<C-w>h")
map("n", "<C-j>", "<C-w>j")
map("n", "<C-k>", "<C-w>k")
map("n", "<C-l>", "<C-w>l")

-- Resize windows
map("n", "<C-Up>", ":resize -2<CR>")
map("n", "<C-Down>", ":resize +2<CR>")
map("n", "<C-Left>", ":vertical resize -2<CR>")
map("n", "<C-Right>", ":vertical resize +2<CR>")

-- jk exit
map("i", "jk", "<Esc>")

-- command remap
map("n", ";", ":")

-- directories
map("n", "<leader>e", "<CMD>Ex<CR>")
