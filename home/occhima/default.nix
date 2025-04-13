{
  home = {
    username = "occhima";
  };

  modules = {
    shell = {
      enable = true;
      type = "zsh";
      prompt.type = "starship";
      cli.enable = true;
    };

    data = {
      xdg.enable = true;
      persistence.enable = true;
      dropbox.enable = true;
    };

    editor = {
      neovim.enable = true;
    };

    desktop = {

      browser.nyxt.enable = true;
      terminal = {
        kitty.enable = true;
      };

      ui = {
        windowManager = "hyprland";
        dock = "waybar";
        launcher = "rofi";
        themes = {
          enable = true;
          name = "guernica";
        };
      };

      apps = {
        flatpak.enable = true;
      };

    };
  };
}
