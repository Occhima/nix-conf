{
  config,
  den,
  hm,
  lib,
  ...
}:
let
  modules = config.flake.modules.homeManager;
  when = app: den.lib.policy.when ({ user, ... }: user.hasAspect app);

  targets = {
    anyrun = "anyrun";
    kitty = "terminal-kitty";
    ghostty = "terminal-ghostty";
    rofi = "rofi";
    mako = "mako-notifier";
    hyprlock = "hyprlock";
    wlogout = "wlogout";
    zellij = "zellij";
    opencode = "opencode";
    waybar = "waybar-dock";
    foliate = "foliate";
    nyxt = "browser-nyxt";
    hyprland = "hyprland";
    zen = "browser-zen-beta";
    calibre = "calibre";
    spicetify = "spotify";
    qutebrowser = "browser-qutebrowser";
    niri = "niri";
    caelestia = "caelestia-dock";
    firefox = "browser-firefox";
  };
in
{
  den.aspects.guernica = lib.mkMerge [
    {
      includes = [
        (hm "themes-guernica")
        (hm "themes-guernica-quickshell-ukishima")
        den.aspects.guernica._
      ];
    }
    (lib.mapAttrs (target: app: {
      includes = [
        (when (den.aspects.${app} or (hm app)) {
          homeManager.imports = [ modules."themes-guernica-${target}" ];
        })
      ];
    }) targets)
  ];
}
