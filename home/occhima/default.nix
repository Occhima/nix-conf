{
  home = {
    username = "occhima";
  };

  modules = {
    profiles = {
      enable = true;
      active = [
        "web"
        "data"
        "ai"
        "dev"
        "science"
        "finance"
        "pentesting"
      ];
    };
    shell = {
      enable = true;

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

      podman = {
        enable = true;
        quadlets = [ "netrunner" ];
      };
      clipboard.enable = false;
      cachix.enable = false;
    };

    dev = {
      python.enable = true;

      # FIXME: disabled bc rstudio is taking too much ram
      r.enable = false;
      haskell.enable = false;
      c.enable = true;
      julia.enable = false;
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
        ghostty.enable = false;
      };

      ui = {
        windowManager = "hyprland";
        dock = "waybar";
        launcher = "anyrun";
        notifier = "mako";
        locker = "hyprlock";
        themes = {
          enable = true;
          name = "guernica";
        };
      };

      apps = {
        flatpak = {
          enable = true;
          packages = [
            "com.github.tchx84.Flatseal"
            "com.github.flxzt.rnote"
          ];

        };
        spotify.enable = true;
        lutris.enable = true;
        discord.enable = true;
        flameshot.enable = true;
        wlogout.enable = true;
        calibre.enable = true;
      };
    };
  };
}
