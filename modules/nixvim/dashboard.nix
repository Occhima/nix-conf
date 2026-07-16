# Nixvim: dashboard — one of several top-level contributors merging
# into `flake.modules.nixvim.default`.
{ ... }:
{
  flake.modules.nixvim.default =
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
    };
}
