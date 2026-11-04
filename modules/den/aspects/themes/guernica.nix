{
  config,
  den,
  lib,
  ...
}:
let
  hm = config.flake.modules.homeManager;
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
      homeManager.imports = with hm; [
        themes-guernica
        themes-guernica-quickshell-ukishima
      ];
      includes = [ den.aspects.guernica._ ];
    }
    (lib.mapAttrs (target: app: {
      includes = [
        (when den.aspects.${app} { homeManager.imports = [ hm."themes-guernica-${target}" ]; })
      ];
    }) targets)
  ];
}
