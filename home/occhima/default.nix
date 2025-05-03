{
  home = {
    username = "occhima";
  };

  modules = {
    shell = {
      enable = true;
      type = "zsh";
      prompt.type = "starship";
      cli = {
        enable = true;
        passwordStore = {
          enable = true;
        };
      };
    };

    data = {
      xdg.enable = true;
      persistence.enable = true;
      maestral = {
        enable = true;
        service = false;
      };
    };

    editor = {
      neovim = {
        enable = true;
      };
      emacs = {
        enable = true;
        service = true;
        default = true;
      };
    };

    dev = {
      python.enable = true;
      haskell.enable = true;
    };

    desktop = {
      browser = {
        firefox.enable = true;
      };
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
        flatpak = {
          packages = [
            "com.github.tchx84.Flatseal"
          ];
          enable = true;
        };
        spotify.enable = true;
      };

    };
  };
}
