return {
	{
		"mfussenegger/nvim-lint",
		event = { "BufWritePost", "BufReadPost", "InsertLeave" }, -- Trigger linting on events
		config = function()
			local lint = require("lint")
			lint.linters_by_ft = {
				go = { "golangcilint" },
				-- Add other filetypes and their linters here, e.g.:
				-- javascript = { "eslint_d" },
				-- typescript = { "eslint_d" },
				-- lua = { "luacheck" },
				-- python = { "flake8" },
				-- sh = { "shellcheck" },
			}

			-- Optional: Customize linter arguments if needed
			-- lint.linters.golangcilint.args = { 'run', '--out-format', 'line-number' }

			-- Create autocommand to run linting
			local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
			vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
				group = lint_augroup,
				callback = function()
					-- Use try_lint without arguments to lint the current buffer
					lint.try_lint()
				end,
			})

			-- Optional: Add keymap for manual linting
			-- vim.keymap.set("n", "<leader>ll", function()
			--   lint.try_lint()
			-- end, { desc = "Trigger linting" })
		end,
	},
}

