{ ... }:

{

  # Custom separators
  separators = {
    dot = {
      format = "";
      interval = "once";
      tooltip = false;
    };
    dot-line = {
      format = "";
      interval = "once";
      tooltip = false;
    };
    line = {
      format = "|";
      interval = "once";
      tooltip = false;
    };
    blank = {
      format = "";
      interval = "once";
      tooltip = false;
    };
    blank_2 = {
      format = "  ";
      interval = "once";
      tooltip = false;
    };
    blank_3 = {
      format = "   ";
      interval = "once";
      tooltip = false;
    };
  };

  # Arrow indicators
  arrows = {
    left = {
      format = "󰁒";
      tooltip = false;
    };
    right = {
      format = "󰁙";
      tooltip = false;
    };
  };

  # Window title module
  window = {
    hyprland = {
      format = "󰣆 {title}";
      max-length = 40;
      separate-outputs = false;
      rewrite = {
        "^.*( — LibreWolf|LibreWolf)$" = "󰈹 LibreWolf";
        "(.*) — Mozilla Firefox" = " Firefox";
        "^.*v( .*|$)" = " Neovim";
        "^.*~$" = "󰄛 Kitty";
        "(.*) " = " Empty";
        "^.*pdf( .*|$)" = "";
        "^.*(- Mousepad)$" = " $1";
      };
    };
  };

  cpu = {
    format = "{icon} {usage}%";
    tooltip = false;
    format-icons = [ "󰻠" ];
  };

  memory = {
    format = "{icon} {percentage}%";
    format-icons = [ "󰍛" ];
  };

  disk = {
    path = "/";
    format = " {percentage_used}%";
    unit = "GB";
  };

  temperature = {
    interval = 10;
    tooltip = true;
    hwmon-path = [
      "/sys/class/hwmon/hwmon6/temp1_input"
      "/sys/class/thermal/thermal_zone0/temp"
    ];
    critical-threshold = 82;
    format-critical = "{temperatureC}°C {icon}";
    format = "{temperatureC}°C {icon}";
    format-icons = [ "󰈸" ];
    on-click-right = "kitty --title nvtop sh -c 'nvtop'";
  };

  # Audio modules
  pulseaudio = {
    format = "{icon} {volume}%";
    format-bluetooth = "{icon} 󰂰 {volume}";
    format-muted = "󰖁";
    format-icons = {
      headphone = "";
      hands-free = "";
      headset = "";
      phone = "";
      portable = "";
      car = "";
      default = [
        ""
        ""
        "󰕾"
        ""
      ];
      ignored-sinks = [
        "Easy Effects Sink"
      ];
    };
    scroll-step = 5.0;
    on-click = "~/.config/hypr/scripts/Volume.sh --toggle";
    on-click-right = "pavucontrol -t 3";
    on-scroll-up = "~/.config/hypr/scripts/Volume.sh --inc";
    on-scroll-down = "~/.config/hypr/scripts/Volume.sh --dec";
    tooltip-format = "{icon} {desc} | {volume}%";
    smooth-scrolling-threshold = 1;
  };

  "pulseaudio#microphone" = {
    format = "{format_source}";
    format-source = " {volume}%";
    format-source-muted = "";
    on-click = "~/.config/hypr/scripts/Volume.sh --toggle-mic";
    on-click-right = "pavucontrol -t 4";
    on-scroll-up = "~/.config/hypr/scripts/Volume.sh --mic-inc";
    on-scroll-down = "~/.config/hypr/scripts/Volume.sh --mic-dec";
    tooltip-format = "{source_desc} | {source_volume}%";
    scroll-step = 5;
  };

  # Media player module
  mpris = {
    interval = 10;
    format = "{player_icon} ";
    format-paused = "{status_icon}";
    on-click-middle = "playerctl play-pause";
    on-click = "playerctl previous";
    on-click-right = "playerctl next";
    scroll-step = 5.0;
    on-scroll-up = "~/.config/hypr/scripts/Volume.sh --inc";
    on-scroll-down = "~/.config/hypr/scripts/Volume.sh --dec";
    smooth-scrolling-threshold = 1;
    player-icons = {
      chromium = "";
      mpd = "";
      default = "";
      firefox = "";
      kdeconnect = "";
      mopidy = "";
      mpv = "󰐹";
      spotify = "";
      vlc = "󰕼";
    };
    status-icons = {
      paused = "󰐎";
      playing = "";
      stopped = "";
    };
    max-length = 10;
  };

  # Battery module
  battery = {
    align = 0;
    rotate = 0;
    full-at = 100;
    design-capacity = false;
    states = {
      good = 95;
      warning = 30;
      critical = 15;
    };
    format = "{icon} {capacity}";
    format-charging = " {capacity}%";
    format-plugged = "󱘖 {capacity}%";
    format-alt-click = "click";
    format-full = "{icon} Full";
    format-alt = "{icon} {time}";
    format-icons = [
      "󰂎"
      "󰁺"
      "󰁻"
      "󰁼"
      "󰁽"
      "󰁾"
      "󰁿"
      "󰂀"
      "󰂁"
      "󰂂"
      "󰁹"
    ];
    format-time = "{H}h {M}min";
    tooltip = true;
    tooltip-format = "{timeTo} {power}w";
    on-click-middle = "~/.config/hypr/scripts/ChangeBlur.sh";
    on-click-right = "~/.config/hypr/scripts/Wlogout.sh";
  };

  # Idle inhibitor
  idle_inhibitor = {
    format = "{icon}";
    format-icons = {
      activated = " ";
      deactivated = " ";
    };
  };

  # Tray
  tray = {
    icon-size = 16;
    spacing = 4;
  };

  # Clock module
  clock = {
    interval = 1;
    format = "{:%I:%M %p}";
    format-alt = " {:%H:%M   %Y, %d %B, %A}";
    tooltip-format = "<tt><small>{calendar}</small></tt>";
    calendar = {
      mode = "year";
      mode-mon-col = 3;
      weeks-pos = "right";
      on-scroll = 1;
      format = {
        months = "<span color='#ffead3'><b>{}</b></span>";
        days = "<span color='#ecc6d9'><b>{}</b></span>";
        weeks = "<span color='#99ffdd'><b>W{}</b></span>";
        weekdays = "<span color='#ffcc66'><b>{}</b></span>";
        today = "<span color='#ff6699'><b><u>{}</u></b></span>";
      };
    };
    actions = {
      on-click-right = "mode";
      on-click-forward = "tz_up";
      on-click-backward = "tz_down";
      on-scroll-up = "shift_up";
      on-scroll-down = "shift_down";
    };
  };

  # Network module
  network = {
    format = "{icon}";
    format-icons = {
      wifi = [ "󰤨" ];
      ethernet = [ "󰈁" ];
      disconnected = [ "" ];
    };
    format-wifi = "󰤨";
    format-ethernet = "󰈁";
    format-disconnected = "󰖪";
    format-linked = "󰈁";
    tooltip = false;
    on-click = "pgrep -x rofi &>/dev/null && notify-send rofi || networkmanager_dmenu";
  };

  "network#speed" = {
    format = " {bandwidthDownBits} ";
    interval = 5;
    tooltip-format = "{ipaddr}";
    tooltip-format-wifi = "{essid} ({signalStrength}%)   \n{ipaddr} | {frequency} MHz{icon} ";
    tooltip-format-ethernet = "{ifname} 󰈀 \n{ipaddr} | {frequency} MHz{icon} ";
    tooltip-format-disconnected = "Not Connected to any type of Network";
    tooltip = true;
    on-click = "pgrep -x rofi &>/dev/null && notify-send rofi || networkmanager_dmenu";
  };

  # Bluetooth modules
  bluetooth = {
    format-on = "";
    format-off = "󰂲";
    format-disabled = "";
    format-connected = "";
    tooltip = false;
    on-click = "overskride";
  };

  "bluetooth#status" = {
    format-on = "";
    format-off = "";
    format-disabled = "";
    format-connected = "<b>{num_connections}</b>";
    format-connected-battery = "<small><b>{device_battery_percentage}%</b></small>";
    tooltip-format = "{controller_alias}\t{controller_address}\n\n{num_connections} connected";
    tooltip-format-connected = "{controller_alias}\t{controller_address}\n\n{num_connections} connected\n\n{device_enumerate}";
    tooltip-format-enumerate-connected = "{device_alias}\t{device_address}";
    tooltip-format-enumerate-connected-battery = "{device_alias}\t{device_address}\t{device_battery_percentage}%";
    on-click = "rofi-bluetooth -config ~/.config/rofi/menu.d/network.rasi -i";
  };

  # Custom modules
  "custom/menu" = {
    format = "{}";
    exec = "echo ; echo 󱓟 app launcher";
    interval = 86400;
    tooltip = true;
    on-click = "pkill rofi || rofi -show drun -modi run,drun,filebrowser,window";
    on-click-middle = "~/.config/hypr/UserScripts/WallpaperSelect.sh";
    on-click-right = "~/.config/hypr/scripts/WaybarLayout.sh";
  };

  "custom/power" = {
    format = "⏻";
    exec = "echo ; echo 󰟡 power // blur";
    on-click = "~/.config/hypr/scripts/Wlogout.sh";
    on-click-right = "~/.config/hypr/scripts/ChangeBlur.sh";
    interval = 86400;
    tooltip = true;
  };

  "custom/notifications" = {
    tooltip = false;
    format = "{icon} {}";
    format-icons = {
      notification = "󱅫";
      none = "󰂚";
      dnd-notification = "󰂛";
      dnd-none = "󰂛";
      inhibited-notification = "󰂚";
      inhibited-none = "󰂚";
      dnd-inhibited-notification = "󰂛";
      dnd-inhibited-none = "󰂛";
    };
    return-type = "json";
    exec-if = "which swaync-client";
    exec = "swaync-client -swb";
    on-click = "swaync-client -t -sw";
    on-click-right = "swaync-client -d -sw";
    escape = true;
  };

  "custom/weather" = {
    format = "{}";
    format-alt = "{alt}: {}";
    format-alt-click = "click";
    interval = 3600;
    return-type = "json";
    exec = "~/.config/hypr/UserScripts/Weather.py";
    exec-if = "ping wttr.in -c1";
    tooltip = true;
  };

  "custom/theme-switcher" = {
    format = "";
    tooltip = false;
  };
}
