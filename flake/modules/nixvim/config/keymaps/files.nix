{ ... }:
{
  plugins.telescope.keymaps = {
    # File finding
    "<leader>ff" = {
      action = "git_files";
      options.desc = "Find files (git)";
    };
    "<leader>fF" = {
      action = "find_files";
      options.desc = "Find files (all)";
    };
    "<leader>fr" = {
      action = "oldfiles";
      options.desc = "Recent files";
    };

    # Search
    "<leader>fg" = {
      action = "live_grep";
      options.desc = "Grep files";
    };
    "<leader>f/" = {
      action = "current_buffer_fuzzy_find";
      options.desc = "Search buffer";
    };

    # Help / misc
    "<leader>fh" = {
      action = "help_tags";
      options.desc = "Help tags";
    };
    "<leader>`" = {
      action = "marks";
      options.desc = "Marks";
    };
    "<leader>\"" = {
      action = "registers";
      options.desc = "Registers";
    };

    # LSP via telescope
    "gr" = {
      action = "lsp_references";
      options.desc = "References";
    };
    "gA" = {
      action = "diagnostics";
      options.desc = "All diagnostics";
    };
    "gs" = {
      action = "treesitter";
      options.desc = "Symbols";
    };
  };
}
