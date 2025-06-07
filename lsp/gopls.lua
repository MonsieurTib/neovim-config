return {
	settings = {
		gopls = {
			analyses = {
				unusedparams = true,
				-- Uncomment the following line to disable govet in gopls
				-- printf = false,  -- This disables the Printf analyzer that causes duplicate warnings
			},
			usePlaceholders = true,
			completeUnimported = true,
			staticcheck = true,
			gofumpt = true,
			hints = {
				compositeLiteralFields = true,
				constantValues = true,
				parameterNames = true,
				functionTypeParameters = true,
			},
		},
	},
} 