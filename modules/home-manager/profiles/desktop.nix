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
        hm.browser-nyxt
        hm.browser-qutebrowser
        hm.terminal-kitty
        hm.hyprland
        # hm.niri
        hm.mako-notifier
        hm.hyprlock
        hm.themes-guernica
        # hm.themes-guernica-niri
        hm.themes-guernica-quickshell-ukishima
        # Guernica integrations for the applications this desktop composes.
        hm.themes-guernica-zen
        hm.themes-guernica-qutebrowser
        hm.themes-guernica-spicetify
        hm.flatpak
        hm.spotify
        hm.discord # vesktop wraps EOL electron; re-enable once nixpkgs bumps electron
        # hm.grimblast
        hm.flameshot
        hm.wlogout
        hm.foliate
        hm.calibre
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
