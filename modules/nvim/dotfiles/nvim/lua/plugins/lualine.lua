-- Statusline (lualine)
local add = require("plugins.add")
add 'nvim-lualine/lualine.nvim'
local function lualine_theme()
  local ok, theme_colors = pcall(require, "theme")
  local c = ok and theme_colors or nil
  if not c then return "auto" end
  return {
    normal = {
      a = { fg = c.background, bg = c.accent, bold = true },
      b = { fg = c.foreground, bg = c.lighter_background },
      c = { fg = c.foreground, bg = c.background },
    },
    insert = {
      a = { fg = c.background, bg = c.green, bold = true },
    },
    visual = {
      a = { fg = c.background, bg = c.magenta, bold = true },
    },
    replace = {
      a = { fg = c.background, bg = c.red, bold = true },
    },
    command = {
      a = { fg = c.background, bg = c.yellow, bold = true },
    },
    inactive = {
      a = { fg = c.muted, bg = c.background },
      b = { fg = c.muted, bg = c.background },
      c = { fg = c.muted, bg = c.background },
    },
  }
end
require("lualine").setup({
  options = {
    theme = lualine_theme(),
    component_separators = "",
    section_separators = { left = "", right = "" },
    globalstatus = true,
  },
  sections = {
    lualine_a = { "mode" },
    lualine_b = {
      { "branch", icon = "" },
      { "diff", symbols = { added = "+", modified = "~", removed = "-" } },
    },
    lualine_c = { "filename" },
    lualine_x = { "filetype" },
    lualine_y = {},
    lualine_z = { "location" },
  },
})
