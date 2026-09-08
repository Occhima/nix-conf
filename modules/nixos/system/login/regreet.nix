# greetd + ReGreet: GTK4 greeter under cage, styled with the polykai palette.
# Palette mirrors the home-manager guernica theme (stylix base16 "polykai"):
# modules/home-manager/desktop/ui/themes/collection/guernica/colors.nix
{
  flake.modules.nixos.login-regreet =
    {
      config,
      pkgs,
      ...
    }:
    let
      # Nix store path => world-readable, so the `greeter` user can load it
      # (home directories are unreadable to the greeter).
      wallpaper = pkgs.nixos-artwork.wallpapers.nineish-dark-gray.gnomeFilePath;
    in
    {
      config = {
        services.displayManager.regreet = {
          enable = true;

          font = {
            package = pkgs.nerd-fonts.iosevka;
            name = "Iosevka Nerd Font";
            size = 12;
          };

          settings = {
            background = {
              path = "${wallpaper}";
              fit = "Cover";
            };
            appearance.greeting_msg = "Welcome back";
            GTK.application_prefer_dark_theme = true;
            widget.clock.format = "%a %H:%M";
          };

          extraCss = ''
            /* polykai: bg #141818, fg #f8f8f8, purple #c080ff */
            window {
              background: transparent;
            }

            entry {
              color: #f8f8f8;
              background-color: rgba(20, 24, 24, 0.85);
              border-radius: 12px;
              padding: 8px;
            }

            button {
              color: #f8f8f8;
              background-color: rgba(20, 24, 24, 0.85);
              border-radius: 12px;
            }

            button:hover {
              background-color: #c080ff;
              color: #141818;
            }
          '';
        };
      };
    };
}
