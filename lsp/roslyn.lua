-- Roslyn C# Language Server
-- Note: This uses the seblyng/roslyn.nvim plugin, not standard lspconfig
return {
  -- Roslyn-specific settings would go here
  -- The actual setup is handled by the roslyn.nvim plugin
  filetypes = { "cs" },
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
      dotnet_suppress_inlay_hints_for_parameters_that_differ_only_by_suffix = false,
      dotnet_suppress_inlay_hints_for_parameters_that_match_argument_name = false,
      dotnet_suppress_inlay_hints_for_parameters_that_match_method_intent = false,
    },
  },
  -- Add any custom roslyn settings here if needed in the future
}

