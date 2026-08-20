-- Highlight yanked text
data_autocmd = vim.api.nvim_create_autocmd

data_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank({
      higroup = "IncSearch",
      timeout = 300,
    })
  end,
})
