-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
vim.opt.number = true
vim.opt.relativenumber = true

local o = vim.opt

-- Tabs
o.expandtab = true
o.shiftwidth = 4
o.tabstop = 4
o.softtabstop = 4
o.smartindent = true

-- Search
o.ignorecase = true
o.smartcase = true
o.hlsearch = false

-- Splits
o.splitbelow = true
o.splitright = true

-- Window
-- Requires Neovim 0.11+
o.winborder = "rounded"

-- Cursor
vim.opt.guicursor = "n-v-c:block,i-ci:ver25,r-cr:hor20"
