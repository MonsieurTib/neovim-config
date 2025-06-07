return {
	settings = {
		terraform = {
			format = {
				enable = true,
				formatOnSave = true,
			},
			experimentalFeatures = {
				validateOnSave = true,
			},
			validation = {
				enableEnhancedValidation = true,
			},
		},
	},
	filetypes = { "terraform", "tf", "terraform-vars" },
} 