{
  lib,
  config,
  uiCfg,
}:

let
  # Import shared module definitions
  modules = import ./modules.nix { inherit config lib uiCfg; };
  compactWorkspacesModule = "${uiCfg.windowManager}/workspaces";
in
{

  settings.mainBar = {
    layer = "top";
    position = "top";
    height = 34;
    width = 1200;
    margin-left = 50;
    margin-right = 50;
    margin-top = 5;

    fixed-center = true;
    reload_style_on_change = true;

    # Module layout
    modules-left = [
      "custom/menu"
      "custom/separator#blank"
      "${uiCfg.windowManager}/window"
      "group/info"
    ];

    modules-center = [
      compactWorkspacesModule
    ];

    modules-right = [
      "idle_inhibitor"
      "group/demo"
      "group/hub"
      "custom/power"
    ];

    # Workspaces configuration using shared modules
    window = {
      hyprland = {
        format = "󰣆 {title}";
        max-length = 40;
        separate-outputs = false;
        rewrite = {
          "(.*) — Mozilla Firefox" = " Firefox";
          "(.*) — Zen Browser" = " Zen";
          "^.*v( .*|$)" = " Emacs";
          "^.*~$" = "󰄛 Kitty";
          "(.*) " = " Empty";
          "^.*pdf( .*|$)" = "";
          "^.*(- Mousepad)$" = " $1";
        };
      };
    };

    workspaces = {
      hyprland = {
        format = " {icon} ";
        show-special = false;
        active-only = false;
        on-click = "activate";
        on-scroll-up = "hyprctl dispatch workspace e+1";
        on-scroll-down = "hyprctl dispatch workspace e-1";
        all-outputs = true;
        sort-by-number = true;
        persistent-workspaces = {
          "11" = [ ];
          "12" = [ ];
          "13" = [ ];
          "14" = [ ];
        };
        format-icons = {
          "11" = " ";
          "12" = " ";
          "13" = " ";
          "14" = " ";
          "15" = "";
          "16" = " ";
          "17" = "";
          "18" = " ";
          "19" = " ";
          "21" = " ";
          "22" = " ";
          "23" = " ";
          "24" = " ";
          "25" = "";
          "26" = " ";
          "27" = "";
          "28" = " ";
          "29" = " ";
          focused = "";
          default = "";
        };
      };
    };

    # Separators
    "custom/separator#blank" = modules.separators.blank;

    # Custom menu
    "custom/menu" = modules."custom/menu";

    "group/info" = {
      orientation = "inherit";
      drawer = {
        transition-duration = 300;
        transition-left-to-right = false;
      };
      modules = [
        "custom/arrow-right"
        "cpu"
        "memory"
        "temperature"
      ];
    };

    "custom/arrow-right" = modules.arrows.right;
    cpu = {
      format = "󰘚 {usage}󱉸";
    };

    memory = {
      interval = 10;
      format = "{used:0.1f}G 󰾆";
      format-alt = "{percentage}% 󰾆";
      format-alt-click = "click";
      tooltip = true;
      tooltip-format = "{used:0.1f}GB/{total:0.1f}G";
      on-click-right = "kitty --title btop sh -c 'btop'";

    };

    disk = modules.disk;
    temperature = modules.temperature;

    # Demo group (audio, tray, media)
    "group/demo" = {
      orientation = "inherit";
      modules = [
        "group/custom_right"
        "battery"
      ];
    };

    "group/custom_right" = {
      orientation = "horizontal";
      modules = [
        "tray"
        "pulseaudio"
        "mpris"
      ];
    };

    tray = modules.tray;
    pulseaudio = modules.pulseaudio;
    mpris = modules.mpris;
    battery = modules.battery;
    idle_inhibitor = modules.idle_inhibitor;

    # Hub group (utilities and clock)
    "group/hub" = {
      orientation = "inherit";
      modules = [
        "group/utils"
        "clock"
      ];
    };

    "group/utils" = {
      orientation = "inherit";
      drawer = {
        transition-duration = 300;
        transition-left-to-right = true;
      };
      modules = [
        "custom/arrow-left"
        "custom/notifications"
        "custom/weather"
        "custom/theme-switcher"
      ];
    };

    "custom/arrow-left" = modules.arrows.left;
    "custom/notifications" = modules."custom/notifications";
    "custom/weather" = modules."custom/weather";
    "custom/theme-switcher" = modules."custom/theme-switcher";

    clock = modules.clock;
    "custom/power" = modules."custom/power";
  };

  style = with config.lib.stylix.colors; ''
    @define-color foreground #${base05};
    @define-color background #${base00};
    @define-color background-alt #${base01};
    @define-color muted #${base04};
    @define-color accent #${base0C};
    @define-color accent-strong #${base0D};

    @define-color color0 #${base00};
    @define-color color1 #${base01};
    @define-color color2 #${base02};
    @define-color color3 #${base03};
    @define-color color4 #${base04};
    @define-color color5 #${base05};
    @define-color color6 #${base06};
    @define-color color7 #${base07};
    @define-color color8 #${base08};
    @define-color color9 #${base09};
    @define-color color10 #${base0A};
    @define-color color11 #${base0B};
    @define-color color12 #${base0C};
    @define-color color13 #${base0D};
    @define-color color14 #${base0E};
    @define-color color15 #${base0F};

    @define-color bar-bg alpha(@background, 0.6);
    @define-color card-bg alpha(@accent-strong, 0.3);
    @define-color card-alt alpha(@accent, 0.4);
    @define-color tray-bg alpha(@accent-strong, 0.3);
    @define-color tooltip-bg alpha(@background, 0.8);
    @define-color tooltip-border alpha(@accent, 0.8);
    @define-color group-bg alpha(@background, 0.5);
    @define-color workspace-bg alpha(@accent-strong, 0.09);
    @define-color subtle-accent mix(@accent, @foreground, 0.30);
    @define-color strong-accent mix(@accent, @foreground, 0.15);
    @define-color muted-accent  mix(@accent-strong, @foreground, 0.40);


    * {
      all: unset; /* isolate Waybar from GTK defaults */
      font: bold 14px "JetBrainsMono Nerd Font";
      font-feature-settings: '"zero", "ss01", "ss02", "ss03", "ss04", "ss05", "cv31"';
      min-height: 0;
      border: none;
      border-radius: 0;
      box-shadow: none;
      text-shadow: none;
    }

    window#waybar {
      background: @bar-bg;
      border-radius: 5px;
    }

    window#waybar.empty,
    window#waybar.empty #window {
      background-color: transparent;
    }

    #window {
      padding: 0px 8px;
      margin: 5px 4px;
      background: @card-bg;
      border-radius: 5px;
      color: @subtle-accent;
    }

    tooltip {
      background: @tooltip-bg;
      border: 2px solid @tooltip-border;
      border-radius: 10px;
    }

    tooltip label {
      color: @foreground;
    }

    /* Module group containers to match compact height */
    .modules-left,
    .modules-center,
    .modules-right {
      padding: 2px 4px;
      margin: 0 6px;
      background: @group-bg;
      border-radius: 8px;
    }

    /* Workspaces */
    #workspaces {
      margin: 4px 4px;
      padding: 0px 4px;
      background: @workspace-bg;
      border-radius: 5px;
    }

    #workspaces button {
      padding: 0px 4px;
      margin: 0px;
      color: alpha(@foreground, 0.3);
      transition: color 0.5s ease, background-color 0.3s ease;
    }

    #workspaces button.active {
      color: @strong-accent;
    }

    #workspaces button.urgent,
    #workspaces button:hover {
      color: @accent-strong;
      background-color: transparent;
    }

    /* Info modules */
    #cpu,
    #memory,
    #temperature,
    #disk {
      padding: 0px 6px;
      margin: 4px 4px;
      background: @card-alt;
      color: @accent;
      border-radius: 10px;
    }

    #custom-arrow-right,
    #custom-arrow-left {
      color: @accent;
      margin: 0px 4px;
    }

    #demo,
    #group-info,
    #group-demo,
    #group-hub,
    #group-utils {
      padding: 0px 6px;
      margin: 4px 2px;
      color: @muted-accent;
      background: alpha(@accent, 0.08);
      border-radius: 5px;
    }

    #bluetooth,
    #network,
    #pulseaudio {
      padding: 4px 4px;
      margin-left: 4px;
      color: @subtle-accent;
    }

    #pulseaudio-slider slider {
      min-height: 0px;
      min-width: 0px;
      background-color: transparent;
      border: none;
      box-shadow: none;
    }

    #pulseaudio-slider {
      margin: 6px;
    }

    #pulseaudio-slider highlight {
      border-radius: 8px;
      background-color: alpha(@accent, 0.8);
    }

    #language {
      padding: 0px 3px 2px 0px;
    }

    #custom-notifications,
    #custom-weather,
    #custom-theme-switcher {
      padding: 0px 8px;
      margin: 8px 4px;
      color: @accent;
      background: mix(@accent, @background, 20);
      border-radius: 10px;
    }

    #tray {
      padding: 0px 8px;
      margin: 4px 2px;
      background: @tray-bg;
      border-radius: 5px;
      color: @subtle-accent;
    }

    #custom-menu,
    #custom-power {
      padding: 0px 8px;
      margin: 6px 6px 6px 4px;
      border-radius: 5px;
      background: @tray-bg;
      color: @subtle-accent;
    }

    #clock {
      padding: 0px 8px;
      margin: 5px 2px 5px 4px;
      background: @tray-bg;
      border-radius: 5px;
      color: @subtle-accent;
    }

    #idle_inhibitor,
    #battery,
    #mpris {
      padding: 4px 4px;
      color: @subtle-accent;
    }
  '';
}
