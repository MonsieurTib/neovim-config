return {
	{
		"tpope/vim-fugitive",
	},
	{
		"lewis6991/gitsigns.nvim",
		config = function()
			require("gitsigns").setup()

			vim.keymap.set("n", "<leader>gh", "<CMD>Gitsigns preview_hunk<CR>", { desc = "[G]it preview [H]unk" })
			vim.keymap.set("n", "<leader>gb", "<CMD>Gitsigns toggle_current_line_blame<CR>", { desc = "[G]it [B]lame" })
		end,
	},
}
