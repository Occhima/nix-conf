{
  flake.modules.homeManager.themes-guernica-opencode =
    { config, lib, ... }:
    let
      c = config.lib.stylix.colors;
      color = x: "#${x}";
      mix =
        a: b: weight:
        "#"
        +
          lib.concatMapStrings
            (
              offset:
              let
                channel = value: lib.fromHexString (builtins.substring offset 2 value);
                value = (channel a * weight + channel b * (8 - weight)) / 8;
              in
              lib.fixedWidthString 2 "0" (lib.toHexString value)
            )
            [
              0
              2
              4
            ];
      scale = x: {
        "100" = mix c.base07 x 4;
        "200" = color x;
        "300" = mix x c.base00 7;
        "400" = mix x c.base00 6;
        "500" = mix x c.base00 5;
        "600" = mix x c.base00 4;
        "700" = mix x c.base00 3;
        "800" = mix x c.base00 2;
        "900" = mix x c.base00 1;
      };
      action = base: { inherit base; };
      bg = color c.base00;
      panel = color c.base01;
      element = color c.base02;
      muted = color c.base04;
      fg = color c.base05;
      accent = color c.base0D;
      error = color c.base0E;
      warning = color c.base08;
      success = color c.base0A;
      string = color c.base0B;
      secondary = color c.base09;
      operator = color c.base0C;
      feedback = {
        error = action error;
        warning = action warning;
        success = action success;
        info = action accent;
      };
    in
    {
      programs.opencode = {
        themes.guernica = {
          base = {
            categorical = [
              "blue"
              "purple"
              "green"
              "yellow"
            ];
            text = {
              base = fg;
              inherit muted feedback;
              action = {
                primary = action accent;
                secondary = action fg;
                destructive = action error;
              };
              formfield = action fg;
            };
            background = {
              base = bg;
              raised = {
                base = panel;
                high = element;
                max = element;
              };
              action = {
                primary = action panel;
                secondary = action panel;
                destructive = action panel;
              };
              formfield = action panel;
              feedback = lib.mapAttrs (_: _: action panel) feedback;
            };
            border.base = color c.base03;
            scrollbar.base = accent;
            diff = {
              text = {
                added = success;
                removed = error;
                context = muted;
                hunkHeader = accent;
              };
              background = {
                added = panel;
                removed = panel;
                context = bg;
              };
              highlight = {
                added = success;
                removed = error;
              };
              lineNumber = {
                text = muted;
                background = {
                  added = panel;
                  removed = panel;
                };
              };
            };
            syntax = {
              comment = muted;
              keyword = error;
              function = accent;
              variable = fg;
              inherit string operator;
              number = secondary;
              type = success;
              punctuation = fg;
            };
            markdown = {
              text = fg;
              heading = accent;
              link = secondary;
              linkText = accent;
              code = string;
              blockQuote = muted;
              emphasis = success;
              strong = fg;
              horizontalRule = muted;
              listItem = accent;
              listEnumeration = accent;
              image = accent;
              imageText = fg;
              codeBlock = string;
            };
          };
          dark.hue = {
            gray = {
              "100" = color c.base07;
              "200" = fg;
              "300" = color c.base06;
              "400" = muted;
              "500" = color c.base03;
              "600" = element;
              "700" = panel;
              "800" = bg;
              "900" = bg;
            };
            red = scale c.base0E;
            orange = scale c.base08;
            yellow = scale c.base0B;
            green = scale c.base0A;
            cyan = scale c.base0C;
            blue = scale c.base0D;
            purple = scale c.base09;
            accent = "$hue.blue";
            interactive = "$hue.blue";
            neutral = "$hue.gray";
          };
        };
        cli.theme.name = "guernica";
      };
    };
}
