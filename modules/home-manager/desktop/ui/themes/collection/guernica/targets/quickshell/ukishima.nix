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
        cp -R ${./shared}/. "$out/"
        cp -R ${./configs/ukishima}/. "$out/"
        chmod -R u+w "$out"
        substituteInPlace "$out/data/Settings.qml" \
          --replace-fail '@base00@' '${colors.base00}' \
          --replace-fail '@base01@' '${colors.base01}' \
          --replace-fail '@base02@' '${colors.base02}' \
          --replace-fail '@base03@' '${colors.base03}' \
          --replace-fail '@base05@' '${colors.base05}' \
          --replace-fail '@base08@' '${colors.base08}' \
          --replace-fail '@base09@' '${colors.base09}' \
          --replace-fail '@base0A@' '${colors.base0A}' \
          --replace-fail '@base0C@' '${colors.base0C}' \
          --replace-fail '@base0D@' '${colors.base0D}' \
          --replace-fail '@base0E@' '${colors.base0E}'
      '';
    in
    {
      imports = [ hm.themes-guernica-quickshell-common ];

      programs.quickshell = {
        activeConfig = configName;
        configs.${configName} = themedConfig;
      };

      # The feature that exposes this IPC owns its bindings for both
      # compositors. Existing application shortcuts remain untouched.
      programs.niri.settings.binds = {
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
    };
}
