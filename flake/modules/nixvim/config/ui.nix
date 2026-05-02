{ ... }:
{
  plugins.lualine = {
    enable = true;
    settings.options = {
      globalstatus = true;
      section_separators = {
        left = "";
        right = "";
      };
      component_separators = {
        left = "│";
        right = "│";
      };
    };
  };

  plugins.notify = {
    enable = true;
    settings = {
      timeout = 2500;
      stages = "fade";
      render = "default";
      top_down = true;
    };
  };

  plugins.noice = {
    enable = true;
    settings.presets = {
      command_palette = true;
      long_message_to_split = true;
      lsp_doc_border = true;
    };
  };

  plugins.dressing.enable = true;

  plugins.which-key = {
    enable = true;
    settings.delay = 300;
  };

  plugins.gitsigns = {
    enable = true;
    settings.signs = {
      add.text = "▎";
      change.text = "▎";
      delete.text = "";
      topdelete.text = "";
      changedelete.text = "▎";
      untracked.text = "▎";
    };
  };

  opts = {
    termguicolors = true;
    number = true;
    relativenumber = true;
    cursorline = true;
    signcolumn = "yes";
    laststatus = 3;
    pumblend = 10;
    winblend = 8;
  };
}
