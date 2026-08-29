local add = require("plugins")

add 'nvim-lua/plenary.nvim'
add 'nvim-telescope/telescope.nvim'

local map = vim.keymap.set
local tel = require('telescope.builtin')

map('n', "<leader>f", tel.find_files, {desc = "find file"})
map('n', "<leader>/", tel.live_grep, {desc = "live grep"})
map('n', "<leader>b", tel.buffers, {desc = "find buffer"})
map('n', "<leader>g", tel.git_files, {desc = "find git file"})

