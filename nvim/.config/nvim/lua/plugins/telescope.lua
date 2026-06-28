return {
    {
        "nvim-telescope/telescope.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-telescope/telescope-fzf-native.nvim",
        },

        build = "make",

        config = function()
            local telescope = require("telescope")
            telescope.setup({})
            pcall(telescope.load_extension, "fzf")

            local builtin = require("telescope.builtin")
            local map = vim.keymap.set

            map("n", "<leader>ff", builtin.find_files , { desc = "Find Files" })
            map("n", "<leader><leader>", builtin.find_files, { desc = "Find Files" })
            map("n", "<leader>fg", builtin.live_grep , { desc = "Live Grep" })
            map("n", "<leader>fb", builtin.buffers , { desc = "Buffers" })
            map("n", "<leader>fh", builtin.help_tags , { desc = "Help" })
        end,
    }   
}
