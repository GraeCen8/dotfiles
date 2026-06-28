return {
    {
        "akinsho/toggleterm.nvim",
        version = "*",
        config = function()
            local toggleterm = require("toggleterm")
            toggleterm.setup({
                size = 15,
                open_mapping = false,
                hide_numbers = true,
                shade_filetypes = {},
                shade_terminals = true,
                start_in_insert = true,
                insert_mappings = false,
                terminal_mappings = true,
                persist_size = true,
                direction = "horizontal",
                close_on_exit = true,
            })

            local Terminal = require("toggleterm.terminal").Terminal
            local horizontal_term = Terminal:new({ direction = "horizontal", hidden = true })

            local map = vim.keymap.set
            map("n", "<leader>h", function()
                horizontal_term:toggle()
            end, { desc = "Toggle horizontal terminal" })
            map("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode", noremap = true, silent = true })
        end,
    },
}
