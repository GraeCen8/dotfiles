require "nvchad.mappings"


local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

-- control binds

map("i", "<Ctr-1>", "\\")
map("i", "<Ctr-2>", "\\n")
map("i", "<Ctr-3>", "|")
map("i", "<Ctr-4>", "~")

-- telescope <Ctr-f> as well as <leader> 
map("n", "<Ctr-}}f>", "<leader>f")


