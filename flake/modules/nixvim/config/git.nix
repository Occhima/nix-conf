{ ... }:
{
  plugins.gitsigns = {
    enable = true;
    settings = {
      current_line_blame = false;
    };
  };

  plugins.neogit = {
    enable = true;
    settings = {
      integrations = {
        telescope = true;
        diffview = true;
      };
    };
  };

  plugins.diffview.enable = true;
}
