{ ... }:
{
  plugins.telescope.keymaps = {
    "<leader>bb" = {
      action = "buffers ignore_current_buffer=true sort_mru=true";
      options.desc = "List buffers";
    };
  };

  keymaps = [
    {
      mode = "n";
      key = "<leader>bn";
      action = "<cmd>bn<CR>";
      options.desc = "Next buffer";
    }
    {
      mode = "n";
      key = "<leader>bp";
      action = "<cmd>bp<CR>";
      options.desc = "Prev buffer";
    }
    {
      mode = "n";
      key = "<leader>bd";
      action = "<cmd>Bdelete<CR>";
      options.desc = "Delete buffer";
    }
  ];
}
