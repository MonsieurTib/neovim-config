return {
	{
		"github/copilot.vim",
		config = function()
			vim.g.copilot_no_tab_map = true
			vim.g.copilot_assume_mapped = true

			vim.keymap.set("i", "<C-j>", "copilot#Next()", { silent = true, expr = true, replace_keycodes = false })
			vim.keymap.set("i", "<C-k>", "copilot#Previous()", { silent = true, expr = true, replace_keycodes = false })
			vim.keymap.set("i", "<C-h>", "copilot#Dismiss()", { silent = true, expr = true, replace_keycodes = false })
			vim.keymap.set("i", "<C-l>", 'copilot#Accept("")', { silent = true, expr = true, replace_keycodes = false })
		end,
	},
	{

		"hrsh7th/nvim-cmp",
		dependencies = {
			--			"Snikimonkd/cmp-go-pkgs",

			-- sourcescmp
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/nvim-cmp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-nvim-lua",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-vsnip",

			-- snippets
			"L3MON4D3/LuaSnip",
			"saadparwaiz1/cmp_luasnip",
			"rafamadriz/friendly-snippets",
			"onsails/lspkind.nvim",
		},
		config = function()
			local cmp = require("cmp")

			local luasnip = require("luasnip")

			local lspkind = require("lspkind")

			-- loads vscode style snippets from installed plugins (e.g. friendly-snippets)
			require("luasnip.loaders.from_vscode").lazy_load()

			cmp.setup({
				completion = {
					completeopt = "menu,menuone,preview",
					preselect = "item",
				},
				snippet = { -- configure how nvim-cmp interacts with snippet engine
					expand = function(args)
						luasnip.lsp_expand(args.body)
					end,
				},
				window = {
					completion = cmp.config.window.bordered(),
					--documentation = cmp.config.window.bordered(),
				},
				mapping = cmp.mapping.preset.insert({
					["<C-k>"] = cmp.mapping.select_prev_item(), -- previous suggestion
					["<C-j>"] = cmp.mapping.select_next_item(), -- next suggestion
					["<C-b>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),
					["<C-Space>"] = cmp.mapping.complete(), -- show completion suggestions
					["<C-e>"] = cmp.mapping.abort(), -- close completion window
					["<CR>"] = cmp.mapping.confirm({ select = true }),
					["<Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_next_item()
						elseif luasnip.expand_or_jumpable() then
							luasnip.expand_or_jump()
						else
							fallback()
						end
					end, { "i", "s" }),
					["<S-Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_prev_item()
						elseif luasnip.jumpable(-1) then
							luasnip.jump(-1)
						else
							fallback()
						end
					end, { "i", "s" }),
				}),
				-- sources for autocompletion
				sources = cmp.config.sources({
					{ name = "nvim_lsp" },
					{ name = "luasnip" }, -- snippets
					{ name = "buffer" }, -- text within current buffer
					{ name = "path" }, -- file system paths
				}),

				-- configure lspkind for vs-code like pictograms in completion menu
				formatting = {
					format = lspkind.cmp_format({
						maxwidth = 50,
						ellipsis_char = "...",
					}),
				},
			})
		end,
	},
}
