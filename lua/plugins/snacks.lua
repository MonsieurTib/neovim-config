return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	---@type snacks.Config
	opts = {
		indent = {
			enabled = true,
			char = "│", -- character to use for indent lines
			blank = " ", -- character for blank lines
			scope = {
				enabled = true, -- highlight current scope
				char = "│",
			},
		},
		lazygit = {},
	},
	config = function(_, opts)
		require("snacks").setup(opts)
		
		-- Set color for unscoped indentation lines
		vim.api.nvim_set_hl(0, "SnacksIndent", { fg = "#393F5D" })
		
		-- Optional: Set color for scoped (current scope) indentation lines
		-- vim.api.nvim_set_hl(0, "SnacksIndentScope", { fg = "#7C3AED" })
	end,
	keys = {
		{
			"<leader>lg",
			function()
				Snacks.lazygit.open()
			end,
			desc = "[L]azy [G]it",
		},
	},
}
