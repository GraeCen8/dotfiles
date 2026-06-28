return {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = {
        "nvim-lua/plenary.nvim",
    },

    config = function()
        local harpoon = require("harpoon")

        harpoon:setup()

        local map = vim.keymap.set

        map("n", "<leader>a", function()
            harpoon:list():add()
        end, { desc = "Harpoon Add"} )
        
        map("n", "<leader>,", function ()
            harpoon.ui:toggle_quick_menu(harpoon:list())
        end, { desc = "Harpoon Menu" })

        map("n", "<leader>1", function()
            harpoon:list():select(1)
        end)

        map("n", "<leader>2", function()
            harpoon:list():select(2)
        end)

        map("n", "<leader>3", function()
            harpoon:list():select(3)
        end)
    end,
}
