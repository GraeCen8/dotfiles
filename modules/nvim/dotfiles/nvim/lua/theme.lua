-- Omarchy theme: read colors.toml and apply dynamically
local function load_omarchy_theme()
	local colors_path = vim.fn.expand("~/.local/state/omarchy/current/theme/colors.toml")
	local f = io.open(colors_path, "r")
	if not f then return nil end
	local c = {}
	for line in f:lines() do
		local key, val = line:match('^([%w_]+)%s*=%s*"(#[%x]+)"')
		if key and val then c[key] = val end
	end
	f:close()
	return c
end

local c = load_omarchy_theme()
if c then
	vim.api.nvim_set_hl(0, "Normal", { fg = c.foreground, bg = c.background })
	vim.api.nvim_set_hl(0, "Comment", { fg = c.muted, italic = true })
	vim.api.nvim_set_hl(0, "Constant", { fg = c.yellow })
	vim.api.nvim_set_hl(0, "String", { fg = c.green })
	vim.api.nvim_set_hl(0, "Identifier", { fg = c.blue })
	vim.api.nvim_set_hl(0, "Function", { fg = c.blue })
	vim.api.nvim_set_hl(0, "Statement", { fg = c.magenta })
	vim.api.nvim_set_hl(0, "PreProc", { fg = c.magenta })
	vim.api.nvim_set_hl(0, "Type", { fg = c.yellow })
	vim.api.nvim_set_hl(0, "Special", { fg = c.orange })
	vim.api.nvim_set_hl(0, "Error", { fg = c.red })
	vim.api.nvim_set_hl(0, "Todo", { fg = c.accent, bold = true })
	vim.api.nvim_set_hl(0, "Search", { fg = c.background, bg = c.accent })
	vim.api.nvim_set_hl(0, "Visual", { bg = c.selection })
	vim.api.nvim_set_hl(0, "CursorLine", { bg = c.lighter_background })
	vim.api.nvim_set_hl(0, "LineNr", { fg = c.muted })
	vim.api.nvim_set_hl(0, "CursorLineNr", { fg = c.foreground, bold = true })
	vim.api.nvim_set_hl(0, "StatusLine", { fg = c.background, bg = c.accent, bold = true })
	vim.api.nvim_set_hl(0, "Pmenu", { fg = c.foreground, bg = c.lighter_background })
	vim.api.nvim_set_hl(0, "PmenuSel", { fg = c.background, bg = c.accent })
	vim.api.nvim_set_hl(0, "TabLine", { fg = c.muted, bg = c.background })
	vim.api.nvim_set_hl(0, "TabLineFill", { bg = c.background })
	vim.api.nvim_set_hl(0, "TabLineSel", { fg = c.foreground, bg = c.background, bold = true })
	vim.api.nvim_set_hl(0, "DiagnosticError", { fg = c.red })
	vim.api.nvim_set_hl(0, "DiagnosticWarn", { fg = c.yellow })
	vim.api.nvim_set_hl(0, "DiagnosticInfo", { fg = c.blue })
	vim.api.nvim_set_hl(0, "DiagnosticHint", { fg = c.cyan })
	vim.api.nvim_set_hl(0, "DiffAdd", { fg = c.green })
	vim.api.nvim_set_hl(0, "DiffDelete", { fg = c.muted })
	vim.api.nvim_set_hl(0, "DiffChange", { fg = c.yellow })
	vim.api.nvim_set_hl(0, "MatchParen", { bg = c.selection, bold = true })
else
	vim.cmd("colorscheme desert")
end

return c
