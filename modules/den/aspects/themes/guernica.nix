{ config, den, ... }:
let
  hm = config.flake.modules.homeManager;
  when = app: den.lib.policy.when ({ user, ... }: user.hasAspect app);
in
{
  den.aspects.guernica = {
    homeManager.imports = with hm; [
      themes-guernica
      themes-guernica-quickshell-ukishima
    ];
    includes = [ den.aspects.guernica._ ];

    anyrun.includes = [
      (when den.aspects.anyrun { homeManager.imports = [ hm.themes-guernica-anyrun ]; })
    ];
    kitty.includes = [
      (when den.aspects.terminal-kitty { homeManager.imports = [ hm.themes-guernica-kitty ]; })
    ];
    ghostty.includes = [
      (when den.aspects.terminal-ghostty { homeManager.imports = [ hm.themes-guernica-ghostty ]; })
    ];
    rofi.includes = [
      (when den.aspects.rofi { homeManager.imports = [ hm.themes-guernica-rofi ]; })
    ];
    mako.includes = [
      (when den.aspects.mako-notifier { homeManager.imports = [ hm.themes-guernica-mako ]; })
    ];
    hyprlock.includes = [
      (when den.aspects.hyprlock { homeManager.imports = [ hm.themes-guernica-hyprlock ]; })
    ];
    wlogout.includes = [
      (when den.aspects.wlogout { homeManager.imports = [ hm.themes-guernica-wlogout ]; })
    ];
    zellij.includes = [
      (when den.aspects.zellij { homeManager.imports = [ hm.themes-guernica-zellij ]; })
    ];
    opencode.includes = [
      (when den.aspects.opencode { homeManager.imports = [ hm.themes-guernica-opencode ]; })
    ];
    waybar.includes = [
      (when den.aspects.waybar-dock { homeManager.imports = [ hm.themes-guernica-waybar ]; })
    ];
    foliate.includes = [
      (when den.aspects.foliate { homeManager.imports = [ hm.themes-guernica-foliate ]; })
    ];
    nyxt.includes = [
      (when den.aspects.browser-nyxt { homeManager.imports = [ hm.themes-guernica-nyxt ]; })
    ];
    hyprland.includes = [
      (when den.aspects.hyprland { homeManager.imports = [ hm.themes-guernica-hyprland ]; })
    ];
    zen.includes = [
      (when den.aspects.browser-zen-beta { homeManager.imports = [ hm.themes-guernica-zen ]; })
    ];
    calibre.includes = [
      (when den.aspects.calibre { homeManager.imports = [ hm.themes-guernica-calibre ]; })
    ];
    spotify.includes = [
      (when den.aspects.spotify { homeManager.imports = [ hm.themes-guernica-spicetify ]; })
    ];
    qutebrowser.includes = [
      (when den.aspects.browser-qutebrowser { homeManager.imports = [ hm.themes-guernica-qutebrowser ]; })
    ];
    niri.includes = [
      (when den.aspects.niri { homeManager.imports = [ hm.themes-guernica-niri ]; })
    ];
    caelestia.includes = [
      (when den.aspects.caelestia-dock { homeManager.imports = [ hm.themes-guernica-caelestia ]; })
    ];
    firefox.includes = [
      (when den.aspects.browser-firefox { homeManager.imports = [ hm.themes-guernica-firefox ]; })
    ];
  };
}
