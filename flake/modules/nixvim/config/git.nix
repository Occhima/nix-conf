{ ... }:
{
  plugins.gitsigns = {
    enable = true;
    settings = {
      current_line_blame = false;
      signs = {
        add.text = "▎";
        change.text = "▎";
        delete.text = "";
        topdelete.text = "";
        changedelete.text = "▎";
        untracked.text = "▎";
      };
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
