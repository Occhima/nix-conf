# Guernica styling for qutebrowser. Explicit integration module: importing
# Requires `themes-guernica` in the same composition (homeManager.desktop provides it).
# `browser-qutebrowser` alone no longer activates any theme configuration.
{
  flake.modules.homeManager.themes-guernica-qutebrowser =
    { config, lib, ... }:
    let
      inherit (config.lib.stylix.colors) withHashtag;
      colors = config.lib.stylix.colors;
      fonts = config.stylix.fonts;

      channel = base: component: lib.toInt colors."${base}-rgb-${component}";

      hex2 =
        value:
        let
          digits = "0123456789abcdef";
          clamped =
            if value > 255 then
              255
            else if value < 0 then
              0
            else
              value;
        in
        builtins.substring (clamped / 16) 1 digits + builtins.substring (lib.mod clamped 16) 1 digits;

      mix =
        base: over: weight:
        let
          blend =
            component: (channel base component * weight + channel over component * (100 - weight)) / 100;
        in
        "#${hex2 (blend "r")}${hex2 (blend "g")}${hex2 (blend "b")}";

      tint = base: weight: mix base "base00" weight;

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

      accent = cyan;
      hintBg = yellow;

      selectedBg = tint "base05" 14;
      selectedHardBg = tint "base05" 20;
      selectedFg = fg;
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

        hints = {
          border = "1px solid ${tint "base0B" 60}";
          radius = 8;
        };

        colors = {
          completion = {
            category = {
              bg = bg;
              fg = accent;
              border = {
                bottom = line;
                top = line;
              };
            };

            even.bg = bg;
            odd.bg = bg;
            fg = dim;

            item.selected = {
              bg = selectedBg;
              fg = selectedFg;
              match.fg = accent;
              border = {
                bottom = selectedHardBg;
                top = selectedHardBg;
              };
            };

            match.fg = accent;

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
              bg = selectedBg;
              fg = selectedFg;
            };
            disabled = {
              bg = bg;
              fg = dim;
            };
          };

          downloads = {
            bar.bg = bg;
            start = {
              bg = tint "base0D" 24;
              fg = fg;
            };
            stop = {
              bg = tint "base0A" 24;
              fg = fg;
            };
            error = {
              bg = tint "base0E" 26;
              fg = fg;
            };
          };

          hints = {
            bg = hintBg;
            fg = bg;
            match.fg = magenta;
          };

          keyhint = {
            bg = panel;
            fg = fg;
            suffix.fg = accent;
          };

          messages = {
            info = {
              bg = tint "base0D" 18;
              fg = fg;
              border = line;
            };
            warning = {
              bg = tint "base08" 20;
              fg = fg;
              border = orange;
            };
            error = {
              bg = tint "base0E" 26;
              fg = fg;
              border = magenta;
            };
          };

          prompts = {
            bg = bg;
            fg = fg;
            border = "1px solid ${line}";
            selected = {
              bg = selectedBg;
              fg = selectedFg;
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
                bg = tint "base0C" 20;
                fg = violet;
              };
            };
            insert = {
              bg = tint "base0A" 20;
              fg = green;
            };
            passthrough = {
              bg = tint "base09" 20;
              fg = blue;
            };
            private = {
              bg = tint "base0C" 20;
              fg = violet;
            };
            caret = {
              bg = tint "base0B" 20;
              fg = yellow;
              selection = {
                bg = tint "base0E" 22;
                fg = magenta;
              };
            };
            progress.bg = accent;
            url = {
              fg = fg;
              hover.fg = accent;
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
                bg = selectedHardBg;
                fg = selectedFg;
              };
              odd = {
                bg = selectedHardBg;
                fg = selectedFg;
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
                  bg = selectedBg;
                  fg = selectedFg;
                };
                odd = {
                  bg = selectedBg;
                  fg = selectedFg;
                };
              };
            };
            indicator = {
              start = accent;
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
