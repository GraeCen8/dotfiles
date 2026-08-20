-- Auto pairs & autotag
local add = require("plugins.add")
add 'windwp/nvim-autopairs'
add 'windwp/nvim-ts-autotag'
require('nvim-autopairs').setup { check_ts = true }
require('nvim-ts-autotag').setup()
