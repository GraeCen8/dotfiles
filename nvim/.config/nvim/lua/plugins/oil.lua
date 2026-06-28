return {
    "stevearc/oil.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
        require("oil").setup {
            columns = { "icon" },
            keymaps = {
                ["<C-h>"] = false,
                ["<M-h>"] = "actions.select_split",
            },
            view_options = {
                show_hidden = true,
            },
        }
        local map = vim.keymap.set

        -- open parent directory in current window
        map("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })

        -- open parent directory in floating window
        map("n", "<leader>-", require("oil").toggle_float)
    end,
}
