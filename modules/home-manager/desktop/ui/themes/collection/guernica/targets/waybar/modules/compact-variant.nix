{
  lib,
  config,
  uiCfg,
}:

let
  # Import shared module definitions
  modules = import ./modules.nix { inherit config lib uiCfg; };

  # Window manager specific workspace module name
  compactWorkspacesModule = "${uiCfg.windowManager}/workspaces#4";
in
{
  # Compact variant configuration following the JaKooLit Hyprlust style
  # https://github.com/NischalDawadi/Hyprlust

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
    ${compactWorkspacesModule} = modules.workspaces.hyprland;

    # Separators
    "custom/separator#blank" = modules.separators.blank;

    # Custom menu
    "custom/menu" = modules."custom/menu";

    # Window title
    "hyprland/window" = modules.window.hyprland;

    # Info group (expandable drawer with system info)
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
    cpu = modules.cpu;
    memory = modules.memory;
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

  # Black & White MonoChrome styling
  style = ''
    * {
      font-family: ${config.stylix.fonts.monospace.name};
      font-weight: bold;
      min-height: 0;
      font-size: 97%;
      font-feature-settings: '"zero", "ss01", "ss02", "ss03", "ss04", "ss05", "cv31"';
      padding: 1px;
    }

    window#waybar {
      background: transparent;
    }

    window#waybar.empty {
      background-color: transparent;
    }

    window#waybar.empty #window {
      background-color: transparent;
    }

    tooltip {
      color: white;
      background: #1e1e2e;
      opacity: 0.8;
      border-radius: 10px;
      border-width: 2px;
      border-style: solid;
      border-color: white;
    }

    tooltip label {
      color: #cdd6f4;
    }

    /* Module groups */
    .modules-right {
      background-color: black;
      color: white;
      border-bottom: 1px;
      border-style: solid;
      border-color: white;
      border-radius: 10px;
      padding-top: 2px;
      padding-bottom: 2px;
      padding-right: 4px;
      padding-left: 4px;
    }

    .modules-center {
      background-color: black;
      color: white;
      border-bottom: 1px;
      border-style: solid;
      border-color: white;
      border-radius: 10px;
      padding-top: 2px;
      padding-bottom: 2px;
      padding-right: 4px;
      padding-left: 4px;
    }

    .modules-left {
      background-color: black;
      color: white;
      border-bottom: 1px;
      border-style: solid;
      border-color: white;
      border-radius: 10px;
      padding-top: 2px;
      padding-bottom: 2px;
      padding-right: 4px;
      padding-left: 4px;
    }

    /* Workspaces */
    #workspaces button {
      box-shadow: none;
      text-shadow: none;
      padding: 0px;
      border-radius: 9px;
      padding-left: 4px;
      padding-right: 4px;
      animation: gradient_f 20s ease-in infinite;
      transition: all 0.5s cubic-bezier(.55,-0.68,.48,1.682);
    }

    #workspaces button:hover {
      color: white;
      background-color: rgba(0,153,153,0.2);
      padding-left: 2px;
      padding-right: 2px;
      animation: gradient_f 20s ease-in infinite;
      transition: all 0.3s cubic-bezier(.55,-0.68,.48,1.682);
    }

    #workspaces button.active {
      color: white;
      padding-left: 8px;
      padding-right: 8px;
      animation: gradient_f 20s ease-in infinite;
      transition: all 0.3s cubic-bezier(.55,-0.68,.48,1.682);
    }

    #workspaces button.persistent {
      border-radius: 10px;
    }

    /* Individual modules */
    #backlight,
    #backlight-slider,
    #battery,
    #bluetooth,
    #clock,
    #cpu,
    #disk,
    #idle_inhibitor,
    #keyboard-state,
    #memory,
    #mode,
    #mpris,
    #network,
    #pulseaudio,
    #pulseaudio-slider,
    #taskbar,
    #temperature,
    #tray,
    #window,
    #wireplumber,
    #workspaces,
    #custom-backlight,
    #custom-cycle_wall,
    #custom-hint,
    #custom-keyboard,
    #custom-light_dark,
    #custom-lock,
    #custom-menu,
    #custom-power_vertical,
    #custom-power,
    #custom-swaync,
    #custom-updater,
    #custom-weather,
    #custom-weather.clearNight,
    #custom-weather.cloudyFoggyDay,
    #custom-weather.cloudyFoggyNight,
    #custom-weather.default,
    #custom-weather.rainyDay,
    #custom-weather.rainyNight,
    #custom-weather.severe,
    #custom-weather.showyIcyDay,
    #custom-weather.snowyIcyNight,
    #custom-weather.sunnyDay {
      padding-top: 3px;
      padding-bottom: 3px;
      padding-right: 6px;
      padding-left: 6px;
    }

    /* Indicators */
    #idle_inhibitor.activated {
      color: #2dcc36;
    }

    #pulseaudio.muted {
      color: #cc3436;
    }

    #temperature.critical {
      color: #cc3436;
    }

    @keyframes blink {
      to {
        color: #000000;
      }
    }

    #battery.critical:not(.charging) {
      color: #f53c3c;
      animation-name: blink;
      animation-duration: 0.5s;
      animation-timing-function: linear;
      animation-iteration-count: infinite;
      animation-direction: alternate;
    }

    #taskbar button.active {
      background-color: #7f849c;
      padding-left: 6px;
      padding-right: 6px;
      animation: gradient_f 20s ease-in infinite;
      transition: all 0.3s cubic-bezier(.55,-0.68,.48,1.682);
    }

    #taskbar button:hover {
      padding-left: 2px;
      padding-right: 2px;
      animation: gradient_f 20s ease-in infinite;
      transition: all 0.3s cubic-bezier(.55,-0.68,.48,1.682);
    }

    /* Sliders */
    #pulseaudio-slider slider {
      min-width: 0px;
      min-height: 0px;
      opacity: 0;
      background-image: none;
      border: none;
      box-shadow: none;
    }

    #pulseaudio-slider trough {
      min-width: 80px;
      min-height: 5px;
      border-radius: 5px;
    }

    #pulseaudio-slider highlight {
      min-height: 10px;
      border-radius: 5px;
    }

    #backlight-slider slider {
      min-width: 0px;
      min-height: 0px;
      opacity: 0;
      background-image: none;
      border: none;
      box-shadow: none;
    }

    #backlight-slider trough {
      min-width: 80px;
      min-height: 10px;
      border-radius: 5px;
    }

    #backlight-slider highlight {
      min-width: 10px;
      border-radius: 5px;
    }
  '';
}
