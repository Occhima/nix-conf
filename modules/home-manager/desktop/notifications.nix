{
  flake.modules.homeManager.desktop-notifications =
    { lib, ... }:
    {
      options.modules.desktop.notifications.backend = lib.mkOption {
        type = lib.types.enum [
          "quickshell"
          "mako"
        ];
        default = "quickshell";
        description = ''
          Notification daemon to run. Only one backend owns
          org.freedesktop.Notifications at a time.
        '';
      };
    };
}
