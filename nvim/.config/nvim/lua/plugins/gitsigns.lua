return {
    {
        "lewis6991/gitsigns.nvim",

        opts = {},

        config = function (_, opts)
            require("gitsigns").setup(opts)

            local gs = require("gitsigns")
            local map = vim.keymap.set

            map("n", "]h", gs.next_hunk)
            map("n", "[h", gs.prev_hunk)

            map("n", "<leader>hs", gs.stage_hunk)
            map("n", "<leader>hr", gs.reset_hunk)
            map("n", "<leader>hp", gs.preview_hunk)
        end
    },
}
