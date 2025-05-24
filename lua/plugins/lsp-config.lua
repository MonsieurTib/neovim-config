return {
	{
		"williamboman/mason.nvim",
		config = function()
			require("mason").setup()
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = {
					"lua_ls",
					"gopls",
					"terraformls",
					"zls",
					"angularls",
					"ts_ls",
					"cssls",
					"html",
				},
			})
		end,
	},
	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		config = function()
			require("mason-tool-installer").setup({
				ensure_installed = {
					"prettier",
					"eslint_d",
					"stylua",
					"delve",
					"golangci-lint",
				},
			})
		end,
	},
	{
		"neovim/nvim-lspconfig",
		config = function()
			local lspconfig = require("lspconfig")

			local lspconfig_defaults = require("lspconfig").util.default_config
			lspconfig_defaults.capabilities = vim.tbl_deep_extend(
				"force",
				lspconfig_defaults.capabilities,
				require("cmp_nvim_lsp").default_capabilities()
			)

			--local capabilities =
			--	require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())

			lspconfig.gopls.setup({
				settings = {
					gopls = {
						analyses = {
							unusedparams = true,
						},
						usePlaceholders = true,
						completeUnimported = true,
						staticcheck = true,
						gofumpt = true,
						--	semanticTokens = true,
						["ui.inlayhint.hints"] = {
							compositeLiteralFields = true,
							constantValues = true,
							parameterNames = true,
							functionTypeParameters = true,
						},
					},
				},
			})

			lspconfig.dockerls.setup({
				settings = {
					docker = {
						languageserver = {
							formatter = {
								ignoreMultilineInstructions = true,
							},
						},
					},
				},
			})

			lspconfig.html.setup({})
			lspconfig.zls.setup({})
			-- TypeScript
			lspconfig.ts_ls.setup({
				{
					init_options = {
						plugins = {
							{
								--	name = "@vue/typescript-plugin",
								--	location = "/usr/local/lib/node_modules/@vue/typescript-plugin",
								--	languages = { "javascript", "typescript", "vue" },
							},
						},
					},
					filetypes = {
						"javascript",
						"typescript",
					},
				},
			})
			lspconfig.terraformls.setup({
				settings = {
					terraform = {
						-- Enable terraform fmt on save
						format = {
							enable = true,
							formatOnSave = true,
						},
						-- Enable detailed logs for debugging
						experimentalFeatures = {
							validateOnSave = true,
						},
						-- Configure validation settings
						validation = {
							enableEnhancedValidation = true,
						},
					},
				},
				filetypes = { "terraform", "tf", "terraform-vars" },
			})
			lspconfig.angularls.setup({
				on_new_config = function(new_config, new_root_dir)
					-- Dynamically set the project path based on the detected project root
					local project_library_path = new_root_dir

					-- Create command with the detected project path
					new_config.cmd = {
						"ngserver",
						"--stdio",
						"--tsProbeLocations",
						project_library_path,
						"--ngProbeLocations",
						project_library_path,
					}
				end,
				-- Root directory detection - will look for these files to identify Angular projects
				root_dir = require("lspconfig").util.root_pattern("angular.json", "project.json", ".git"),
			})
			lspconfig.lua_ls.setup({})

			vim.api.nvim_create_autocmd("LspAttach", {
				desc = "LSP actions",
				callback = function(event)
					local opts = { buffer = event.buf }

					vim.keymap.set("n", "<leader>it", function()
						vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
					end, { desc = "Refactoring: Toggle inlay hints" })

					vim.keymap.set("n", "<leader>gt", function()
						require("telescope.builtin").lsp_type_definitions()
					end, { desc = "[G]oto [T]ype definition" })

					vim.keymap.set("n", "<leader>gd", function()
						require("telescope.builtin").lsp_definitions()
					end, { desc = "[G]oto [D]efinition" })

					vim.keymap.set("n", "<leader>gi", function()
						require("telescope.builtin").lsp_implementations()
					end, { desc = "[G]oto [I]mplementation" })

					vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "[C]ode [A]ction" })

					vim.keymap.set("n", "<leader>gr", function()
						require("telescope.builtin").lsp_references()
					end, { desc = "[G]oto [R]eferences" })

					vim.keymap.set("n", "<leader>re", vim.lsp.buf.rename, { desc = "[RE]name" })

					vim.keymap.set("n", "<leader>ds", function()
						require("telescope.builtin").lsp_document_symbols()
					end, { desc = "[D]ocument [S]ymbols" })

					vim.keymap.set("n", "<leader>ws", function()
						require("telescope.builtin").lsp_dynamic_workspace_symbols()
					end, { desc = "[W]orkspace [S]ymbols" })

					vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Refactoring: Hover documentation" })
				end,
			})
		end,
	},
	{
		"seblyng/roslyn.nvim",
		ft = "cs",
		opts = {
			config = {
				settings = {
					["csharp|inlay_hints"] = {
						csharp_enable_inlay_hints_for_implicit_object_creation = true,
						csharp_enable_inlay_hints_for_implicit_variable_types = true,
						csharp_enable_inlay_hints_for_lambda_parameter_types = true,
						csharp_enable_inlay_hints_for_types = true,
						dotnet_enable_inlay_hints_for_indexer_parameters = true,
						dotnet_enable_inlay_hints_for_literal_parameters = true,
						dotnet_enable_inlay_hints_for_object_creation_parameters = true,
						dotnet_enable_inlay_hints_for_other_parameters = true,
						dotnet_enable_inlay_hints_for_parameters = true,
						-- The following suppress hints in certain cases, set to false if you want more hints
						dotnet_suppress_inlay_hints_for_parameters_that_differ_only_by_suffix = true,
						dotnet_suppress_inlay_hints_for_parameters_that_match_argument_name = true,
						dotnet_suppress_inlay_hints_for_parameters_that_match_method_intent = true,
					},
					-- You can add other settings groups here if needed, e.g.:
					-- ["csharp|code_lens"] = {
					--   dotnet_enable_references_code_lens = true,
					-- },
				},
			},
		},
	},
}
