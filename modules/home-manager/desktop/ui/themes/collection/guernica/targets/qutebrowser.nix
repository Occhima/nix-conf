# Guernica styling for qutebrowser. Explicit integration module: importing
# Requires `themes-guernica` in the same composition (homeManager.desktop provides it).
# `browser-qutebrowser` alone no longer activates any theme configuration.
{
  flake.modules.homeManager.themes-guernica-qutebrowser =
    { config, ... }:
    let
      inherit (config.lib.stylix.colors) withHashtag;
      fonts = config.stylix.fonts;

      bg = withHashtag.base00;
      panel = withHashtag.base01;
      line = withHashtag.base02;
      dim = withHashtag.base03;
      fg = withHashtag.base05;

      orange = withHashtag.base08;
      blue = withHashtag.base09;
      green = withHashtag.base0A;
      yellow = withHashtag.base0B;
      violet = withHashtag.base0C;
      cyan = withHashtag.base0D;
      magenta = withHashtag.base0E;
    in
    {
      # Guernica dresses qutebrowser itself; keep stylix's target off.
      stylix.targets.qutebrowser.enable = false;

      programs.qutebrowser.settings = {
        fonts = {
          default_family = fonts.monospace.name;
          default_size = "${toString fonts.sizes.applications}pt";

          web = {
            family = {
              cursive = fonts.serif.name;
              fantasy = fonts.serif.name;
              fixed = fonts.monospace.name;
              sans_serif = fonts.sansSerif.name;
              serif = fonts.serif.name;
              standard = fonts.sansSerif.name;
            };
            size.default = builtins.floor (fonts.sizes.applications * 4 / 3 + 0.5);
          };
        };

        hints.border = "1px solid ${magenta}";

        colors = {
          completion = {
            category = {
              bg = bg;
              fg = magenta;
              border = {
                bottom = bg;
                top = bg;
              };
            };

            even.bg = bg;
            odd.bg = bg;
            fg = dim;

            item.selected = {
              bg = panel;
              fg = fg;
              match.fg = magenta;
              border = {
                bottom = panel;
                top = panel;
              };
            };

            match.fg = magenta;

            scrollbar = {
              bg = bg;
              fg = line;
            };
          };

          contextmenu = {
            menu = {
              bg = bg;
              fg = fg;
            };
            selected = {
              bg = panel;
              fg = fg;
            };
            disabled = {
              bg = bg;
              fg = dim;
            };
          };

          downloads = {
            bar.bg = bg;
            start = {
              bg = bg;
              fg = cyan;
            };
            stop = {
              bg = bg;
              fg = green;
            };
            error = {
              bg = bg;
              fg = magenta;
            };
          };

          hints = {
            bg = magenta;
            fg = bg;
            match.fg = yellow;
          };

          keyhint = {
            bg = panel;
            fg = fg;
            suffix.fg = magenta;
          };

          messages = {
            info = {
              bg = bg;
              fg = cyan;
              border = line;
            };
            warning = {
              bg = bg;
              fg = orange;
              border = line;
            };
            error = {
              bg = bg;
              fg = magenta;
              border = line;
            };
          };

          prompts = {
            bg = panel;
            fg = fg;
            border = "1px solid ${line}";
            selected = {
              bg = line;
              fg = fg;
            };
          };

          statusbar = {
            normal = {
              bg = bg;
              fg = dim;
            };
            command = {
              bg = bg;
              fg = fg;
              private = {
                bg = bg;
                fg = violet;
              };
            };
            insert = {
              bg = bg;
              fg = green;
            };
            passthrough = {
              bg = bg;
              fg = blue;
            };
            private = {
              bg = bg;
              fg = violet;
            };
            caret = {
              bg = bg;
              fg = yellow;
              selection = {
                bg = bg;
                fg = magenta;
              };
            };
            progress.bg = magenta;
            url = {
              fg = fg;
              hover.fg = cyan;
              error.fg = magenta;
              warn.fg = orange;
              success = {
                https.fg = fg;
                http.fg = orange;
              };
            };
          };

          tabs = {
            bar.bg = bg;
            even = {
              bg = bg;
              fg = dim;
            };
            odd = {
              bg = bg;
              fg = dim;
            };
            selected = {
              even = {
                bg = bg;
                fg = fg;
              };
              odd = {
                bg = bg;
                fg = fg;
              };
            };
            pinned = {
              even = {
                bg = bg;
                fg = dim;
              };
              odd = {
                bg = bg;
                fg = dim;
              };
              selected = {
                even = {
                  bg = bg;
                  fg = fg;
                };
                odd = {
                  bg = bg;
                  fg = fg;
                };
              };
            };
            indicator = {
              start = cyan;
              stop = green;
              error = magenta;
            };
          };

          tooltip = {
            bg = panel;
            fg = fg;
          };

          webpage = {
            bg = bg;
            preferred_color_scheme = "dark";
          };
        };
      };
    };
}
