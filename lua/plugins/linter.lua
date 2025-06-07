return {
  {
    "mfussenegger/nvim-lint",
    event = { "BufWritePost", "BufReadPost", "InsertLeave" }, -- Trigger linting on events
    config = function()
      local lint = require("lint")
      lint.linters_by_ft = {
        go = { "golangcilint" },
        lua = { "luacheck" },
        javascript = { "eslint_d" },
        typescript = { "eslint_d" },
        -- python = { "flake8" },
        -- sh = { "shellcheck" },
      }

      local config_file = vim.fn.findfile(".golangci.yml", ".;")
      if config_file == "" then
        config_file = vim.fn.findfile(".golangci.yaml", ".;")
      end

      if config_file ~= "" then
        lint.linters.golangcilint.args = lint.linters.golangcilint.args or {}
        table.insert(lint.linters.golangcilint.args, "--config")
        table.insert(lint.linters.golangcilint.args, config_file)
      end

      -- Create autocommand to run linting
      local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
      vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
        group = lint_augroup,
        callback = function()
          -- Only lint if golangci-lint is available
          local ft = vim.bo.filetype
          if ft == "go" and vim.fn.executable("golangci-lint") == 1 then
            lint.try_lint()
          elseif ft ~= "go" then
            lint.try_lint()
          end
        end,
      })

      -- Add keymap for manual linting
      vim.keymap.set("n", "<leader>ll", function()
        lint.try_lint()
      end, { desc = "Trigger linting for current buffer" })
    end,
  },
}
