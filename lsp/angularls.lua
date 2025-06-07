return {
	cmd = {
		"ngserver",
		"--stdio",
		"--tsProbeLocations", 
		".",
		"--ngProbeLocations",
		".",
	},
	root_dir = function(fname)
		local util = require("lspconfig.util")
		return util.root_pattern("angular.json", "project.json", ".git")(fname)
	end,
} 