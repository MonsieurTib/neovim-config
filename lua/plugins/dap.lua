return {
	"mfussenegger/nvim-dap",
	dependencies = {
		"rcarriga/nvim-dap-ui",
		"nvim-neotest/nvim-nio",
		"leoluz/nvim-dap-go",
		"TheLeoP/powershell.nvim",
		"theHamsta/nvim-dap-virtual-text",
	},
	config = function()
		local dap = require("dap")
		local dapui = require("dapui")

		require("nvim-dap-virtual-text").setup()
		dap.set_log_level("DEBUG")

		require("config.dap.zig")
		require("config.dap.cs")

		local utils = require("dap.utils")
		require("dap-go").setup()
		require("dapui").setup()
		--vim.api.nvim_set_hl(0, "BreakPointHit", { fg = "#000000", bg = "#f38ba8" })

		--DapStopped = { bg = "#FFFF00" }
		vim.fn.sign_define(
			"DapBreakpoint",
			{ text = "🔴", texthl = "DapBreakpoint", linehl = "DapBreakpoint", numhl = "DapBreakpoint" }
		)

		require("powershell").setup({
			bundle_path = vim.fn.stdpath("data") .. "/mason/packages/powershell-editor-services",
		})

		dap.listeners.before.attach.dapui_config = function()
			dapui.open()
		end
		dap.listeners.before.launch.dapui_config = function()
			dapui.open()
		end
		dap.listeners.before.event_terminated.dapui_config = function() end
		dap.listeners.before.event_exited.dapui_config = function() end

		vim.keymap.set("n", "<Leader>df", function()
			dapui.float_element(nil, { enter = true })
		end)

		vim.keymap.set("n", "<F5>", function()
			dap.continue()
		end, { desc = "Debugging - Continue debugging session" })

		vim.keymap.set("n", "<F10>", function()
			dap.step_over()
		end, { desc = "Debugging - Step over" })

		vim.keymap.set("n", "<F11>", function()
			dap.step_into()
		end, { desc = "Debugging - Step into" })

		vim.keymap.set("n", "<F12>", function()
			dap.step_out()
		end, { desc = "Debugging - Step out" })

		vim.keymap.set("n", "<leader>b", function()
			dap.toggle_breakpoint()
		end, { desc = "Debugging - Toggle breakpoint" })

		vim.keymap.set("n", "<F9>", function()
			dap.toggle_breakpoint()
		end, { desc = "Debugging - Toggle breakpoint (alternate key)" })

		vim.keymap.set("n", "<leader>lp", function()
			dap.set_breakpoint(nil, nil, vim.fn.input("Log point message: "))
		end, { desc = "Debugging - Set log point with message" })

		vim.keymap.set("n", "<leader>dt", function()
			dapui.toggle()
		end, { desc = "Debugging - Toggle DAP UI" })

		vim.keymap.set("n", "<S-F5>", function()
			local current_directory = vim.fn.getcwd()
			local go_project = vim.fn.glob(current_directory .. "/go.mod") ~= ""
			local dotnet_project = vim.fn.glob(current_directory .. "/*.sln") ~= ""
				or vim.fn.glob(current_directory .. "/*.csproj") ~= ""

			vim.cmd("split")
			vim.cmd("wincmd w")

			if go_project then
				vim.cmd("term go run .")
			elseif dotnet_project then
				vim.cmd("term dotnet run .")
			else
				print("Not a Go or .NET project.")
			end
		end, { desc = "Debugging - Run project in terminal" })
	end,
}
