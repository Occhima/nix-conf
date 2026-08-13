{
  flake.modules.homeManager.fastfetch = {
    config = {
      programs.fastfetch = {
        enable = true;
        settings = {
          schema = "https://github.com/fastfetch-cli/fastfetch/raw/dev/doc/json_schema.json";
          logo = {
            type = "small";
            padding = {
              top = 1;
              right = 4;
            };
          };
          display = {
            separator = "  ";
            color = {
              keys = "bright_black";
              title = "white";
            };
          };
          modules = [
            "break"
            { type = "title"; }
            "break"
            {
              type = "os";
              key = "󱄅 ";
              format = "{pretty-name}";
            }
            {
              type = "kernel";
              key = "󰻠 ";
              format = "{release}";
            }
            {
              type = "wm";
              key = "󰖳 ";
              format = "{pretty-name}";
            }
            {
              type = "shell";
              key = "󰆍 ";
              format = "{pretty-name}";
            }
            {
              type = "packages";
              key = "󰏖 ";
              format = "{all}";
            }
            {
              type = "uptime";
              key = "󰅐 ";
            }
            {
              type = "memory";
              key = "󰍛 ";
              format = "{used} / {total}";
            }
            "break"
            {
              type = "colors";
              symbol = "circle";
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
