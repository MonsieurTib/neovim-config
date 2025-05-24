return {
	"stevearc/conform.nvim",
	opts = {},
	config = function()
		local conform = require("conform")
		conform.setup({
			formatters_by_ft = {
				lua = { "stylua" },
				javascript = { "prettierd", "prettier", stop_after_first = true },
				typescript = { "prettierd", "prettier", stop_after_first = true },
				go = { "gofumpt", "goimports", "golines" },
				cs = { "csharpier", "dotnet_format" },
				terraform = { "terraform_fmt" },
				json = { "prettierd", "prettier", stop_after_first = true },
				yaml = { "prettierd", "prettier", stop_after_first = true },
				html = { "prettierd", "prettier", stop_after_first = true },
				css = { "prettierd", "prettier", stop_after_first = true },
			},
			formatters = {
				prettier = {
					prepend_args = { "--tab-width", "2", "--use-tabs", "false" },
				},
				prettierd = {
					prepend_args = { "--tab-width", "2", "--use-tabs", "false" },
				},
			},
			format_on_save = {
				-- These options will be passed to conform.format()
				timeout_ms = 500,
				lsp_format = "fallback",
			},
		})
	end,
}
