return {
	"stevearc/conform.nvim", -- automatically format on save
	opts = {},
	lazy = false,
	config = function()
		require("conform").setup({
			formatters_by_ft = {
				go = { "goimports", "gofmt" },
				python = { "ruff_format" },
				terraform = { "terraform_fmt" },
				sh = { "shellcheck" },
				lua = { "stylua" },
				yaml = { "yamlfmt" },
			},

			format_on_save = {
				timeout_ms = 500,
				lsp_format = "fallback",
			},
		})
	end,
}
