local dap = require("dap")

dap.adapters.codelldb = {
	type = "server",
	port = "${port}",
	executable = {
		command = "codelldb",
		args = { "--port", "${port}" },
	},
}

dap.configurations.zig = {
	{
		name = "Launch file",
		type = "codelldb",
		request = "launch",
		program = function()
			local build_command = "zig build"
			local result = vim.fn.system(build_command)
			if vim.v.shell_error ~= 0 then
				print("Build failed: " .. result)
				return nil
			end
			local workspace_folder = vim.fn.getcwd()
			local executable_path = workspace_folder .. "/zig-out/bin/" .. vim.fn.fnamemodify(workspace_folder, ":t")
			return executable_path
		end,
		cwd = "${workspaceFolder}",
		stopOnEntry = false,
	},
}
