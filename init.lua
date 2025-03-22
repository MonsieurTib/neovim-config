vim.cmd("set expandtab")
vim.cmd("set tabstop=2")
vim.cmd("set softtabstop=2")
vim.cmd("set shiftwidth=2")
vim.cmd("autocmd BufEnter * set number")
vim.g.mapleader = " "

require("config.lazy")
require("config.telescope_keymaps")

vim.api.nvim_create_augroup("AutoFormat", { clear = true })

-- Add autocommand to format on save
--vim.api.nvim_create_autocmd("BufWritePre", {
--    group = "AutoFormat",
--    callback = function()
--        vim.lsp.buf.format()
--    end,
--})
local conform = require("conform")
vim.api.nvim_create_autocmd({ "InsertLeave" }, {
	callback = function()
		if vim.bo.modified and not vim.bo.readonly and vim.bo.filetype ~= "gitcommit" then
			--vim.cmd("w")
			conform.format({ async = true })
		end
	end,
	desc = "Auto-save on insert leave, text change, or focus lost...",
})
local keymap = vim.keymap
keymap.set("n", "<leader>sv", ":vsplit<CR>", { noremap = true, silent = true })
keymap.set("i", "jk", "<ESC>", { desc = "Exit insert mode with jk" })
keymap.set("i", "jj", "<ESC>", { desc = "Exit insert mode with jk" })
