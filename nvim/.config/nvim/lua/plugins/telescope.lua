local function telescope(picker, opts)
  return function()
    require("telescope.builtin")[picker](opts or {})
  end
end

return {
  "nvim-telescope/telescope.nvim",
  keys = {
    { "<leader>f/", telescope "current_buffer_fuzzy_find", desc = "Find in buffer" },
    { "<leader>f?", telescope "help_tags", desc = "Find help" },
    { "<leader>f:", telescope "commands", desc = "Find commands" },
    { "<leader>f'", telescope "marks", desc = "Find marks" },
    { "<leader>fb", telescope "buffers", desc = "Find buffers" },
    { "<leader>fc", telescope "command_history", desc = "Find command history" },
    { "<leader>fd", telescope "diagnostics", desc = "Find diagnostics" },
    { "<leader>fD", telescope("diagnostics", { bufnr = 0 }), desc = "Find buffer diagnostics" },
    { "<leader>ff", telescope "find_files", desc = "Find files" },
    { "<leader>fF", telescope("find_files", { hidden = true, no_ignore = true }), desc = "Find all files" },
    { "<leader>fg", telescope "live_grep", desc = "Find text" },
    { "<leader>fG", telescope("live_grep", { grep_open_files = true }), desc = "Find text in open files" },
    { "<leader>fh", telescope "oldfiles", desc = "Find recent files" },
    { "<leader>fj", telescope "jumplist", desc = "Find jumps" },
    { "<leader>fk", telescope "keymaps", desc = "Find keymaps" },
    { "<leader>fl", telescope "loclist", desc = "Find location list" },
    { "<leader>fm", telescope "man_pages", desc = "Find man pages" },
    { "<leader>fq", telescope "quickfix", desc = "Find quickfix" },
    { "<leader>fr", telescope "resume", desc = "Find resume" },
    { "<leader>fR", telescope "registers", desc = "Find registers" },
    { "<leader>fs", telescope "lsp_document_symbols", desc = "Find document symbols" },
    { "<leader>fS", telescope "lsp_workspace_symbols", desc = "Find workspace symbols" },
    { "<leader>ft", telescope "treesitter", desc = "Find treesitter symbols" },
    { "<leader>fw", telescope "grep_string", desc = "Find word under cursor" },
  },
}
