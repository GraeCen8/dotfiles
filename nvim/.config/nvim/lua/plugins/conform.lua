return {
	{
		"stevearc/conform.nvim",

		opts = {
			formatters_by_ft = {
				lua = { "stylua" },
				python = { "black" },
				javascript = { "prettier" },
				typescript = { "prettier" },
				html = { "prettier" },
				css = { "prettier" },
				json = { "prettier" },
				sh = { "shfmt" },
			},

			format_on_save = {
				timeout_ms = 500,
				lsp_fallback = true,
			},
		},

		keys = {
			{
				"<leader>fm",
				function()
					require("conform").format()
				end,
				desc = "Format",
			},
		},
	},
}
