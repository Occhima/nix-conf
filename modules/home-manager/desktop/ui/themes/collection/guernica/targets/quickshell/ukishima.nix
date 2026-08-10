{ config, ... }:
let
  hm = config.flake.modules.homeManager;
  inherit (config.flake.lib.custom) hyprlandLib;
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

      config = lib.mkMerge [
        {
          programs.quickshell = {
            activeConfig = configName;
            configs.${configName} = themedConfig;
          };

          wayland.windowManager.hyprland.settings =
            hyprlandLib.mkBinds config.wayland.windowManager.hyprland.configType
              (
                map
                  (
                    binding:
                    binding
                    // {
                      modifiers = [
                        "SUPER"
                        "CTRL"
                      ];
                      dispatcher = "exec";
                      argument = ipcCommand binding.member;
                      lua = hyprlandLib.luaExec (ipcCommand binding.member);
                    }
                  )
                  [
                    {
                      key = "SPACE";
                      member = "dashboard";
                    }
                    {
                      key = "M";
                      member = "media";
                    }
                    {
                      key = "N";
                      member = "notifications";
                    }
                    {
                      key = "I";
                      member = "network";
                    }
                    {
                      key = "P";
                      member = "power";
                    }
                    {
                      key = "ESCAPE";
                      member = "hide";
                    }
                  ]
              );
        }
      ];
    };

  flake.modules.homeManager.niri =
    { config, lib, ... }:
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
      programs.niri.settings.binds =
        lib.mkIf ((config.programs.quickshell.activeConfig or null) == configName)
          {
            "Mod+Ctrl+Space" = {
              repeat = false;
              hotkey-overlay.title = "Toggle Guernica island";
              action.spawn = ipcArgs "dashboard";
            };
            "Mod+Ctrl+M" = {
              repeat = false;
              hotkey-overlay.title = "Open island media";
              action.spawn = ipcArgs "media";
            };
            "Mod+Ctrl+N" = {
              repeat = false;
              hotkey-overlay.title = "Open island notifications";
              action.spawn = ipcArgs "notifications";
            };
            "Mod+Ctrl+I" = {
              repeat = false;
              hotkey-overlay.title = "Open island connectivity";
              action.spawn = ipcArgs "network";
            };
            "Mod+Ctrl+P" = {
              repeat = false;
              hotkey-overlay.title = "Open island power menu";
              action.spawn = ipcArgs "power";
            };
            "Mod+Ctrl+Escape" = {
              repeat = false;
              hotkey-overlay.title = "Close Guernica island";
              action.spawn = ipcArgs "hide";
            };
          };
    };
}
