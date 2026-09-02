local o = vim.o
o.number = true
o.relativenumber = true
o.tabstop = 2
o.softtabstop = 2
o.signcolumn = "yes"
o.undofile = true
o.autoread = true
o.laststatus = 3
o.cmdheight = 0
o.winborder = "none"
o.clipboard = "unnamedplus"
o.scrolloff = 8
o.winborder = "rounded"

vim.highlight.on_yank()
