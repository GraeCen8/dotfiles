local add = require "plugins"
local map = vim.keymap.set

-- undotree
add 'mbbill/undotree'
map("n", "<leader>u", vim.cmd.UndotreeToggle, {desc = "undo tree"})

-- oil.nvim
add 'stevearc/oil.nvim'
require 'oil'.setup()
map("n", "-", "<Cmd>Oil<Cr>",{desc = "file tree"})

-- autopairs
add 'windwp/nvim-autopairs'
add 'windwp/nvim-ts-autotag'
require('nvim-autopairs').setup { check_ts = true }
require('nvim-ts-autotag').setup()

-- which-key
add "folke/which-key.nvim"
-- require('which-key').setup({})
require('which-key').setup({ preset = "helix" })
require("which-key").add({
  { "g",        group = "goto" },
  { "z",        group = "view" },
  { "<leader>", group = "leader" },
  { "<C-w>",    group = "windows" },
})

-- git
add 'lewis6991/gitsigns.nvim'
add 'kdheepak/lazygit.nvim'
require('gitsigns').setup()
map({"n", "i", "v"}, "<C-g>", "<Cmd>LazyGit<Cr>")

-- Flash.nvim
add 'folke/flash.nvim'
local flash = require('flash')
flash.setup()
map({ "n", "x", "v" }, "s", function() require("flash").jump() end, { desc = "Flash" })

