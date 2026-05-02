{ ... }:
{
  plugins.telescope.keymaps = {
    "<leader>gl" = {
      action = "git_commits";
      options.desc = "Git log";
    };
    "<leader>gB" = {
      action = "git_branches";
      options.desc = "Git branches";
    };
    "<leader>gs" = {
      action = "git_status";
      options.desc = "Git status";
    };
  };

  keymaps = [
    # Neogit
    {
      mode = "n";
      key = "<leader>gg";
      action = "<cmd>Neogit<CR>";
      options.desc = "Neogit";
    }

    # Diffview
    {
      mode = "n";
      key = "<leader>gd";
      action = "<cmd>DiffviewOpen<CR>";
      options.desc = "Diff view";
    }
    {
      mode = "n";
      key = "<leader>gD";
      action = "<cmd>DiffviewClose<CR>";
      options.desc = "Close diff view";
    }

    # Gitsigns: blame
    {
      mode = "n";
      key = "<leader>gb";
      action = "<cmd>Gitsigns toggle_current_line_blame<CR>";
      options.desc = "Toggle line blame";
    }

    # Gitsigns: hunk navigation
    {
      mode = "n";
      key = "]h";
      action = "<cmd>Gitsigns next_hunk<CR>";
      options.desc = "Next hunk";
    }
    {
      mode = "n";
      key = "[h";
      action = "<cmd>Gitsigns prev_hunk<CR>";
      options.desc = "Prev hunk";
    }

    # Gitsigns: hunk actions
    {
      mode = [ "n" "v" ];
      key = "<leader>ghs";
      action = "<cmd>Gitsigns stage_hunk<CR>";
      options.desc = "Stage hunk";
    }
    {
      mode = [ "n" "v" ];
      key = "<leader>ghr";
      action = "<cmd>Gitsigns reset_hunk<CR>";
      options.desc = "Reset hunk";
    }
    {
      mode = "n";
      key = "<leader>ghS";
      action = "<cmd>Gitsigns stage_buffer<CR>";
      options.desc = "Stage buffer";
    }
    {
      mode = "n";
      key = "<leader>ghR";
      action = "<cmd>Gitsigns reset_buffer<CR>";
      options.desc = "Reset buffer";
    }
    {
      mode = "n";
      key = "<leader>ghp";
      action = "<cmd>Gitsigns preview_hunk<CR>";
      options.desc = "Preview hunk";
    }
  ];
}
