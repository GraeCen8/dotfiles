local add = require("plugins")

add("ibhagwan/fzf-lua")

local f = require("fzf-lua")
local map = vim.keymap.set

map("n", "<leader>f", f.files, { desc = "Find files", })
map("n", "<leader>/", f.live_grep, { desc = "Live grep", })
map("n", "<leader>b", f.buffers, { desc = "Find buffers", })
map("n", "<leader>g", f.git_files, { desc = "Git files", })
map("n", "<leader>d", f.diagnostics_document, { desc = "Buffer diagnostics", })
map("n", "<leader>D", f.diagnostics_workspace, { desc = "Workspace diagnostics", })
map("n", "<leader>s", f.lsp_document_symbols, { desc = "Document symbols", })
map("n", "<leader>S", f.lsp_workspace_symbols, { desc = "Workspace symbols", })
map("n", "<leader>'", f.resume, { desc = "last picker", })
