return {
	{
		"williamboman/mason.nvim",
		config = function()
			require("mason").setup()
		end,
	},
	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		config = function()
			require("mason-tool-installer").setup({
				ensure_installed = {
					-- Language servers (use Mason package names)
					"lua-language-server", -- lua_ls
					"gopls", -- gopls
					"terraform-ls", -- terraformls
					"zls", -- zls
					"angular-language-server", -- angularls
					"typescript-language-server", -- ts_ls
					"css-lsp", -- cssls
					"html-lsp", -- html
					"dockerfile-language-server", -- dockerls
					-- Formatters and tools
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
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
		},
		config = function()
			-- Set up default capabilities
			local capabilities = require("cmp_nvim_lsp").default_capabilities()

			-- Configure all servers from lsp/ directory
			local servers_from_lsp_folder = {
				"lua_ls",
				"gopls",
				"ts_ls",
				"terraformls",
				"zls",
				"html",
				"cssls",
				"angularls",
				"dockerls",
				"roslyn", -- Special case: handled by separate plugin
			}

			for _, server in ipairs(servers_from_lsp_folder) do
				-- Load the config from lsp/ directory
				local config_ok, server_config = pcall(require, "lsp." .. server)
				if config_ok then
					-- Special handling for roslyn (uses separate plugin)
					if server == "roslyn" then
						-- Roslyn is handled by the roslyn.nvim plugin below
						-- Just load the config for reference/future use
					else
						server_config.capabilities = capabilities
						vim.lsp.config(server, server_config)
						vim.lsp.enable(server)
					end
				else
					-- Fallback if config file doesn't exist (except for roslyn)
					if server ~= "roslyn" then
						vim.lsp.config(server, { capabilities = capabilities })
						vim.lsp.enable(server)
					end
				end
			end

			-- LSP Keymaps and diagnostics
			vim.api.nvim_create_autocmd("LspAttach", {
				desc = "LSP actions",
				callback = function(event)
					local bufnr = event.buf

					local function map(mode, lhs, rhs, opts)
						opts = opts or {}
						opts.buffer = bufnr
						vim.keymap.set(mode, lhs, rhs, opts)
					end

					-- Essential keymaps
					map("n", "<leader>gd", vim.lsp.buf.definition, { desc = "Go to Definition" })
					map("n", "<leader>gr", vim.lsp.buf.references, { desc = "Go to References" })
					map("n", "<leader>gi", vim.lsp.buf.implementation, { desc = "Go to Implementation" })
					map("n", "<leader>gt", vim.lsp.buf.type_definition, { desc = "Go to Type Definition" })
					map("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code Action" })
					map("n", "<leader>re", vim.lsp.buf.rename, { desc = "Rename" })
					map("n", "K", vim.lsp.buf.hover, { desc = "Hover Documentation" })
					map("n", "<leader>it", function()
						vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr }))
					end, { desc = "Toggle Inlay Hints" })

					-- Auto-enable inlay hints for specific file types
					local ft = vim.bo[bufnr].filetype
					if vim.tbl_contains({ "go", "cs" }, ft) and vim.lsp.inlay_hint then
						vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
					end

					-- Use Telescope for LSP functions if available
					local telescope_ok, telescope_builtin = pcall(require, "telescope.builtin")
					if telescope_ok then
						map("n", "<leader>gd", telescope_builtin.lsp_definitions, { desc = "[G]oto [D]efinition" })
						map("n", "<leader>gr", telescope_builtin.lsp_references, { desc = "[G]oto [R]eferences" })
						map(
							"n",
							"<leader>gi",
							telescope_builtin.lsp_implementations,
							{ desc = "[G]oto [I]mplementation" }
						)
						map(
							"n",
							"<leader>gt",
							telescope_builtin.lsp_type_definitions,
							{ desc = "[G]oto [T]ype definition" }
						)
						map(
							"n",
							"<leader>ds",
							telescope_builtin.lsp_document_symbols,
							{ desc = "[D]ocument [S]ymbols" }
						)
						map(
							"n",
							"<leader>ws",
							telescope_builtin.lsp_dynamic_workspace_symbols,
							{ desc = "[W]orkspace [S]ymbols" }
						)
					end

					-- Format on save for specific file types
					local client = vim.lsp.get_client_by_id(event.data.client_id)
					if client and client.supports_method("textDocument/formatting") then
						vim.api.nvim_create_autocmd("BufWritePre", {
							buffer = bufnr,
							callback = function()
								-- Only format certain file types
								local ft = vim.bo[bufnr].filetype
								if vim.tbl_contains({ "go", "terraform", "lua", "cs" }, ft) then
									vim.lsp.buf.format({ bufnr = bufnr })
								end
							end,
						})
					end
				end,
			})

			-- Diagnostic configuration
			vim.diagnostic.config({
				virtual_text = {
					prefix = "●",
					source = "if_many",
				},
				signs = {
					text = {
						[vim.diagnostic.severity.ERROR] = " ",
						[vim.diagnostic.severity.WARN] = " ",
						[vim.diagnostic.severity.HINT] = " ",
						[vim.diagnostic.severity.INFO] = " ",
					},
				},
				underline = true,
				update_in_insert = false,
				severity_sort = true,
				float = {
					focusable = false,
					style = "minimal",
					border = "rounded",
					source = "always",
					header = "",
					prefix = "",
				},
			})
		end,
	},
	{
		"seblyng/roslyn.nvim",
		ft = "cs",
		config = function()
			-- Load roslyn config from lsp/ directory for consistency
			local config_ok, roslyn_config = pcall(require, "lsp.roslyn")
			
			-- Configure roslyn through vim.lsp.config (the correct way per documentation)
			if config_ok and roslyn_config.settings then
				vim.lsp.config("roslyn", {
					settings = roslyn_config.settings
				})
			end
			
			require("roslyn").setup({
				-- Plugin-specific settings only
			})
		end,
	},
}

