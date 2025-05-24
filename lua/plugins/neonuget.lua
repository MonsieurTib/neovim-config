return {
	"MonsieurTib/neonuget",
	commit = "ae5c450e9864a10dc6e903a036f5c34b964af17b",
	branch = "4-failed-to-parse-package-metadata-when-it-actually-exists",
	config = function()
		require("neonuget").setup({})
	end,
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
}
-- return {}
