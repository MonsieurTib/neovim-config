return {
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
		"MunifTanjim/nui.nvim",
		-- "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
	},
	config = function()
		vim.keymap.set(
			"n",
			"<leader>et",
			"<CMD>Neotree filesystem toggle reveal left <CR>",
			{ desc = "Explorer - toggle" }
		)
		vim.keymap.set("n", "<leader>ef", "<CMD>Neotree filesystem reveal left <CR>", { desc = "Explorer - focus" })
	end,
}
