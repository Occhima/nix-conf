{
  flake.modules.homeManager.hyprland =
    {
      lib,
      config,
      ...
    }:
    let
      inherit (lib) mkIf;
    in
    {
      config = {
        assertions = [
          {
            assertion = lib.all (
              service:
              lib.elem "hyprland-session.target" (service.Install.WantedBy or [ ])
              -> config.wayland.windowManager.hyprland.enable
            ) (lib.attrValues config.systemd.user.services);
            message = "user services target hyprland-session.target while hyprland is disabled";
          }
        ];

        services.hyprpaper = {
          enable = true;
          systemdTarget = "hyprland-session.target";
          settings = {
            ipc = "on";
            splash = false;
            splash_offset = 2;
          };
        };
        services.hypridle = {
          enable = true;
          systemdTarget = "hyprland-session.target";

          settings = mkIf config.programs.hyprlock.enable {
            general = {
              lock_cmd = "pidof hyprlock || hyprlock";
              before_sleep_cmd = "loginctl lock-session";
              after_sleep_cmd = "hyprctl dispatch dpms on";
            };
          };
        };

        services.hyprsunset = {
          enable = false;
        };

        services.hyprpolkitagent = {
          enable = false;
        };
      };
    };
}
