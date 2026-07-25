{ config, ... }:
let
  hm = config.flake.modules.homeManager;
in
{
  flake.modules.homeManager.desktop =
    { lib, ... }:
    {
      imports = [
        hm.browser-zen-beta
        hm.terminal-kitty
        hm.hyprland
        hm.quickshell-dock
        hm.mako-notifier
        hm.anyrun
        hm.hyprlock
        hm.themes-guernica
        # Guernica integrations for the applications this desktop composes.
        hm.themes-guernica-zen
        hm.themes-guernica-spicetify
        hm.flatpak
        hm.spotify
        hm.discord # vesktop wraps EOL electron; re-enable once nixpkgs bumps electron
        hm.grimblast
        hm.wlogout
        # hm.calibre
      ];

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
