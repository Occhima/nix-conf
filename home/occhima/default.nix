{
  home = {
    username = "occhima";
  };

  modules = {
    profiles = {
      enable = true;
      active = [
        "web"
        "ai"
        "dev"
      ];
    };
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
        service = true;
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

    services = {
      espanso.enable = false;
      podman.enable = true;
      clipboard.enable = true;
    };

    dev = {
      python.enable = true;
      haskell.enable = true;
      c.enable = true;
      beancount.enable = true;
    };

    desktop = {
      browser = {
        firefox.enable = true;
        nyxt.enable = true;
      };
      terminal = {
        kitty.enable = true;
      };

      ui = {
        windowManager = "hyprland";
        dock = "waybar";
        launcher = "rofi";
        notifier = "mako";
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
        flameshot.enable = true;
      };

    };
  };
}
