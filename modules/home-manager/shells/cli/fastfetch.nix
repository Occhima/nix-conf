{
  flake.modules.homeManager.fastfetch = {
    config = {
      programs.fastfetch = {
        enable = true;
        settings = {
          "$schema" = "https://github.com/fastfetch-cli/fastfetch/raw/dev/doc/json_schema.json";

          logo = {
            type = "small";
            padding = {
              top = 2;
              left = 2;
              right = 5;
            };
          };

          display = {
            separator = " ➜  ";
            color.separator = "90";
            percent = {
              type = 9;
              ndigits = 0;
            };
            size.ndigits = 1;
          };

          modules = [
            "break"
            {
              type = "title";
              format = "{user-name}@{host-name}";
              color = {
                user = "36";
                at = "90";
                host = "36";
              };
            }
            {
              type = "custom";
              format = "{#90}────────────────────────────────";
            }
            "break"

            {
              type = "os";
              key = "OS   ";
              keyColor = "31";
              format = "{pretty-name}";
            }
            {
              type = "kernel";
              key = " ├ 󰌽 ";
              keyColor = "31";
              format = "{release}";
            }
            {
              type = "packages";
              key = " ├ 󰏖 ";
              keyColor = "31";
              format = "{all} (nix)";
            }
            {
              type = "uptime";
              key = " ├ 󰅐 ";
              keyColor = "31";
            }
            {
              type = "shell";
              key = " └ 󰆍 ";
              keyColor = "31";
              format = "{pretty-name} {version}";
            }
            "break"

            {
              type = "wm";
              key = "WM   ";
              keyColor = "32";
              format = "{pretty-name}";
            }
            {
              type = "theme";
              key = " ├ 󰉼 ";
              keyColor = "32";
            }
            {
              type = "icons";
              key = " ├ 󰀻 ";
              keyColor = "32";
            }
            {
              type = "cursor";
              key = " ├ 󰇀 ";
              keyColor = "32";
            }
            {
              type = "terminal";
              key = " ├ 󰞷 ";
              keyColor = "32";
              format = "{pretty-name}";
            }
            {
              type = "terminalfont";
              key = " └ 󰛖 ";
              keyColor = "32";
            }
            "break"

            {
              type = "host";
              key = "PC   ";
              keyColor = "33";
              format = "{name}";
            }
            {
              type = "cpu";
              key = " ├ 󰻠 ";
              keyColor = "33";
              format = "{name} ({cores-logical}) @ {freq-max}";
            }
            {
              type = "gpu";
              key = " ├ 󰢮 ";
              keyColor = "33";
              format = "{name}";
            }
            {
              type = "memory";
              key = " ├ 󰍛 ";
              keyColor = "33";
            }
            {
              type = "swap";
              key = " ├ 󰓡 ";
              keyColor = "33";
            }
            {
              type = "disk";
              key = " ├ 󰋊 ";
              keyColor = "33";
              folders = "/";
            }
            {
              type = "display";
              key = " └ 󰍹 ";
              keyColor = "33";
              compactType = "original";
            }
            "break"

            {
              type = "colors";
              symbol = "circle";
              paddingLeft = 5;
            }
            "break"
          ];
        };
      };

      home.shellAliases = {
        ff = "fastfetch";
      };
    };
  };
}
