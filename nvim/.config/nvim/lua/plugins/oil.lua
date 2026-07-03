return {
  "stevearc/oil.nvim",
  lazy = false,
  opts = {
    columns = { "icon" },
    keymaps = {
      ["g?"] = "actions.show_help",
      ["<CR>"] = "actions.select",
      ["-"] = "actions.parent",
      ["_"] = "actions.open_cwd",
      ["`"] = "actions.cd",
      ["~"] = "actions.cd",
      ["gs"] = "actions.change_sort",
      ["gx"] = "actions.open_external",
      ["g."] = "actions.toggle_hidden",
      ["g\\"] = "actions.toggle_trash",
    },
    use_default_keymaps = true,
  },
  keys = {
    {
      "-",
      function()
        require("oil").open()
      end,
      mode = "n",
      noremap = true,
      silent = true,
      desc = "Open oil.nvim in current directory",
    },
  },
}
