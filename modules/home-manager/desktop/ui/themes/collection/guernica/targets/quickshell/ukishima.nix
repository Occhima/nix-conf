{ config, ... }:
let
  hm = config.flake.modules.homeManager;
  inherit (config.flake.lib.custom) hyprlandLib;

  # Each surface owns its integration next to the QML which implements it.
  # The same declarative table renders Hyprland and Niri bindings.
  surfaceBindings = [
    {
      key = "SPACE";
      modifiers = [ "SUPER" ];
      niriBind = "Mod+Space";
      member = "launcher";
      title = "Search applications";
    }
    {
      key = "X";
      modifiers = [ "SUPER" ];
      niriBind = "Mod+X";
      member = "clipboard";
      title = "Search clipboard history";
    }
    {
      key = "B";
      modifiers = [
        "SUPER"
        "CTRL"
      ];
      niriBind = "Mod+Ctrl+B";
      member = "bluetooth";
      title = "Open Bluetooth devices";
    }
    {
      key = "M";
      modifiers = [
        "SUPER"
        "CTRL"
      ];
      niriBind = "Mod+Ctrl+M";
      member = "mixer";
      title = "Open display and audio mixer";
    }
    {
      key = "S";
      modifiers = [
        "SUPER"
        "CTRL"
      ];
      niriBind = "Mod+Ctrl+S";
      member = "system";
      title = "Open system performance";
    }
    {
      key = "A";
      modifiers = [
        "SUPER"
        "CTRL"
      ];
      niriBind = "Mod+Ctrl+A";
      member = "calendar";
      title = "Open weather and calendar";
    }
    {
      key = "U";
      modifiers = [
        "SUPER"
        "CTRL"
      ];
      niriBind = "Mod+Ctrl+U";
      member = "media";
      title = "Open media controls";
    }
    {
      key = "N";
      modifiers = [
        "SUPER"
        "CTRL"
      ];
      niriBind = "Mod+Ctrl+N";
      member = "notifications";
      title = "Open notifications";
    }
    {
      key = "I";
      modifiers = [
        "SUPER"
        "CTRL"
      ];
      niriBind = "Mod+Ctrl+I";
      member = "network";
      title = "Open network controls";
    }
    {
      key = "P";
      modifiers = [
        "SUPER"
        "CTRL"
      ];
      niriBind = "Mod+Ctrl+P";
      member = "power";
      title = "Open power menu";
    }
    {
      key = "ESCAPE";
      modifiers = [
        "SUPER"
        "CTRL"
      ];
      niriBind = "Mod+Ctrl+Escape";
      member = "hide";
      title = "Close Guernica surfaces";
    }
  ];
in
{
  flake.modules.homeManager.themes-guernica-quickshell-ukishima =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      inherit (config.lib.stylix) colors;

      configName = "guernica-ukishima";
      ipcTarget = "guernica-island";
      qs = "${config.programs.quickshell.package}/bin/qs";
      ipcArgs = member: [
        qs
        "-c"
        configName
        "ipc"
        "call"
        ipcTarget
        member
      ];
      ipcCommand = member: lib.escapeShellArgs (ipcArgs member);

      themedConfig = pkgs.runCommand "quickshell-${configName}" { } ''
        mkdir -p "$out"
        # Keep the source config directly launchable. The build materializes
        # its links to the neutral shared toolkit, then applies Guernica.
        cp -RL ${./.}/configs/ukishima/. "$out/"
        chmod -R u+w "$out"
        substituteInPlace "$out/data/Settings.qml" \
          --replace-fail '"#141818"' '"#${colors.base00}"' \
          --replace-fail '"#1e2424"' '"#${colors.base01}"' \
          --replace-fail '"#3c4848"' '"#${colors.base02}"' \
          --replace-fail '"#f8f8f8"' '"#${colors.base05}"' \
          --replace-fail '"#909090"' '"#${colors.base03}"' \
          --replace-fail '"#40c4ff"' '"#${colors.base0D}"' \
          --replace-fail '"#ffb000"' '"#${colors.base08}"' \
          --replace-fail '"#a0ff20"' '"#${colors.base0A}"' \
          --replace-fail '"#ff0060"' '"#${colors.base0E}"' \
          --replace-fail '"#c080ff"' '"#${colors.base0C}"' \
          --replace-fail '"#6080ff"' '"#${colors.base09}"' \
          --replace-fail '"#ffe080"' '"#${colors.base0B}"'
      '';
    in
    {
      imports = [ hm.themes-guernica-quickshell-common ];

      programs.quickshell = {
        activeConfig = configName;
        configs.${configName} = themedConfig;
      };

      home.packages = with pkgs; [
        brightnessctl
        cliphist
        wl-clipboard
      ];

      systemd.user.services = {
        guernica-cliphist-text = {
          Unit = {
            Description = "Guernica text clipboard history";
            PartOf = [ "graphical-session.target" ];
            After = [ "graphical-session.target" ];
          };
          Service = {
            ExecStart = "${pkgs.wl-clipboard}/bin/wl-paste --type text --watch ${lib.getExe pkgs.cliphist} store";
            Restart = "on-failure";
            RestartSec = 1;
          };
          Install.WantedBy = [ "graphical-session.target" ];
        };

        guernica-cliphist-image = {
          Unit = {
            Description = "Guernica image clipboard history";
            PartOf = [ "graphical-session.target" ];
            After = [ "graphical-session.target" ];
          };
          Service = {
            ExecStart = "${pkgs.wl-clipboard}/bin/wl-paste --type image --watch ${lib.getExe pkgs.cliphist} store";
            Restart = "on-failure";
            RestartSec = 1;
          };
          Install.WantedBy = [ "graphical-session.target" ];
        };
      };

      wayland.windowManager.hyprland.settings =
        hyprlandLib.mkBinds config.wayland.windowManager.hyprland.configType
          (
            map (binding: {
              inherit (binding) modifiers key;
              dispatcher = "exec";
              argument = ipcCommand binding.member;
              lua = hyprlandLib.luaExec (ipcCommand binding.member);
            }) surfaceBindings
          );
    };

  flake.modules.homeManager.niri =
    { config, ... }:
    let
      configName = "guernica-ukishima";
      ipcTarget = "guernica-island";
      qs = "${config.programs.quickshell.package}/bin/qs";
      ipcArgs = member: [
        qs
        "-c"
        configName
        "ipc"
        "call"
        ipcTarget
        member
      ];
    in
    {
      # Ukishima contributes bindings to hm.niri without importing it into
      # the ordinary desktop graph.
      programs.niri.settings.binds = builtins.listToAttrs (
        map (binding: {
          name = binding.niriBind;
          value = {
            repeat = false;
            hotkey-overlay.title = binding.title;
            action.spawn = ipcArgs binding.member;
          };
        }) surfaceBindings
      );
    };
}
