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
        "science"
        "finance"
        # "pentesting"
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
      # FIXME: broken, can't make it work on my wayland + nvidia machine
      espanso.enable = false;
      podman.enable = false;
      clipboard.enable = true;
      cachix.enable = false;
    };

    dev = {
      python.enable = true;
      haskell.enable = true;
      c.enable = true;
      julia.enable = true;
    };

    desktop = {
      browser = {
        active = "zen";
        firefox.enable = false;
        nyxt.enable = true;
        zen.enable = true;
      };
      terminal = {
        active = "kitty";
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
        discord.enable = true;
        flameshot.enable = true;
      };

    };
  };
}
