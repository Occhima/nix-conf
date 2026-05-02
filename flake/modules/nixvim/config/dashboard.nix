{ ... }:
{
  plugins.alpha = {
    enable = true;
    theme = "dashboard";
  };

  keymaps = [
    {
      mode = "n";
      key = "<leader>h";
      action = "<cmd>Alpha<cr>";
      options.desc = "Home dashboard";
    }
  ];
}
