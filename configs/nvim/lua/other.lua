local add = require "plugins"
local map = vim.keymap.set

-- autocommands
-- vim.api.nvim_create_autocmd("InsertLeave", {
--   callback = function()
--     if vim.bo.modified and vim.bo.buftype == "" then
--       vim.cmd("silent write")
--     end
--   end,
-- })

vim.api.nvim_create_autocmd("VimLeavePre", {
	callback = function()
		vim.cmd("silent! wall")
	end,
})

-- undotree
add 'mbbill/undotree'
map("n", "<leader>u", vim.cmd.UndotreeToggle, { desc = "undo tree" })

-- oil.nvim
add 'stevearc/oil.nvim'
require 'oil'.setup()
map("n", "-", "<Cmd>Oil<Cr>", { desc = "file tree" })

-- git
add 'lewis6991/gitsigns.nvim'
add 'kdheepak/lazygit.nvim'
require('gitsigns').setup()
map({ "n", "i", "v" }, "<C-g>", "<Cmd>LazyGit<Cr>")

-- Flash.nvim
add 'folke/flash.nvim'
local flash = require('flash')
flash.setup()
map({ "n", "x", "v" }, "<C-s>", function() require("flash").jump() end, { desc = "Flash" })

-- icons
add 'nvim-tree/nvim-web-devicons'
