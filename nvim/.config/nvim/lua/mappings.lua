require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")
map("t", "<Esc><Esc>", "<Esc><Esc><C-\\><C-n>", { desc = "exit terminal" })
-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")

map({'i', 'n', 'v'}, '<C-1>', '\\')
map({'i', 'n', 'v'}, '<C-2>', '\\n')
map({'i', 'n', 'v'}, '<C-3>', '|')
map({'i', 'n', 'v'}, '<C-4>', '~')

vim.keymap.set("n", "<Space><Space>", "<leader>ff", { remap = true, desc = 'find files'})
