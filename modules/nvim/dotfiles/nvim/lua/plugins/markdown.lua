-- Markdown renderer
local add = require("plugins.add")
add "MeanderingProgrammer/render-markdown.nvim"
require("render-markdown").setup({
  code = { sign = false, width = "block", right_pad = 1 },
  heading = { sign = false, icons = {} },
  checkbox = { enabled = false },
})
