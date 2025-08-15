{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib) mkIf concatStringsSep;
  cfg = config.modules.system.login;
  accountsCfg = config.modules.accounts;
  displayCfg = config.modules.system.display;

  sessionData = config.services.displayManager.sessionData.desktops;
  sessionPath = concatStringsSep ":" [
    "${sessionData}/share/xsessions"
    "${sessionData}/share/wayland-sessions"
  ];

  commandAttrs = {
    default =
      let
        command = [
          "${pkgs.tuigreet}/bin/tuigreet"
          "--time"
          "--remember"
          "--remember-user-session"
          "--asterisks"
          "--sessions '${sessionPath}'"
        ];
      in
      concatStringsSep " " command;

    # stolen from github.com/hlissner/dotfiles/blob/master/modules/desktop/hyprland.nix
    hyprland = toString (
      pkgs.writeShellScript "hyprland-wrapper" ''
        trap 'systemctl --user stop hyprland-session.target; sleep 1' EXIT
        exec Hyprland >/dev/null
      ''
    );

  };

  # TODO: Login directly in to hyprland with hyprlock
  selectedCommand =
    if displayCfg.enableHyprlandEssentials then commandAttrs.default else commandAttrs.default;
in
{
  config = mkIf (cfg.enable && cfg.manager == "greetd") {
    services.greetd = {
      enable = true;
      # VT1 = 2;
      restart = !cfg.autoLogin;

      settings = {
        default_session = {
          user = accountsCfg.mainUser or "greeter";
          command = selectedCommand;
        };

        initial_session = mkIf cfg.autoLogin {
          user = accountsCfg.mainUser or "root";
          command = "${config.modules.display.wayland.enable}";
        };
      };
    };
  };
}
