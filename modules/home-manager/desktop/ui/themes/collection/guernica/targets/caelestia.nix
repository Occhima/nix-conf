{
  config,
  lib,
  ...
}:

let
  inherit (lib.custom) themeLib;

  stylixFonts = config.stylix.fonts;

in
{
  programs.caelestia.settings = themeLib.whenTheme config "guernica" {
    appearance = {
      anim.durations.scale = 1;
      font.family = {
        sans = stylixFonts.sansSerif.name;
        mono = stylixFonts.monospace.name;
        material = "Material Symbols Rounded";
        clock = stylixFonts.sansSerif.name;
      };
      padding.scale = 1;
      rounding = {
        scale = 1;
        small = 12;
        normal = 18;
        large = 26;
        full = 1000;
      };
      spacing.scale = 1;
      transparency = {
        enabled = false;
        base = 0.9;
        layers = 0.5;
      };
    };

    background = {
      enabled = true;
      desktopClock.enabled = false;
      visualiser = {
        enabled = false;
        autoHide = true;
        blur = false;
        rounding = 1;
        spacing = 1;
      };
    };

    bar = {
      persistent = true;
      showOnHover = true;
      status = {
        showBluetooth = true;
        showNetwork = true;
        showLockStatus = true;
        showAudio = false;
        showMicrophone = false;
        showKbLayout = false;
      };
      workspaces = {
        shown = 5;
        activeIndicator = true;
        occupiedBg = false;
        showWindows = true;
        perMonitorWorkspaces = true;
        label = "  ";
        occupiedLabel = "󰮯";
        activeLabel = "󰮯";
      };
      tray = {
        background = false;
        recolour = false;
        compact = false;
      };
      popouts = {
        activeWindow = true;
        tray = true;
        statusIcons = true;
      };
      entries = [
        {
          id = "logo";
          enabled = true;
        }
        {
          id = "workspaces";
          enabled = true;
        }
        {
          id = "spacer";
          enabled = true;
        }
        {
          id = "activeWindow";
          enabled = true;
        }
        {
          id = "spacer";
          enabled = true;
        }
        {
          id = "tray";
          enabled = true;
        }
        {
          id = "clock";
          enabled = true;
        }
        {
          id = "statusIcons";
          enabled = true;
        }
        {
          id = "power";
          enabled = true;
        }
      ];
    };

    general.apps = {
      terminal = [ config.modules.desktop.terminal.active ];
      audio = [ "pavucontrol" ];
      playback = [ "mpv" ];
      explorer = [ "thunar" ];
    };

    paths.wallpaperDir = builtins.path {
      path = ../assets/wallpapers;
      name = "wallpaper";
    };

    services = {
      smartScheme = false;
      useFahrenheit = false;
      useTwelveHourClock = false;
    };
  };
}
