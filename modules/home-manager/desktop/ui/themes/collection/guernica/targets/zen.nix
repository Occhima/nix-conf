{
  config,
  lib,
  pkgs,
  ...
}:
let

  inherit (lib.custom) themeLib;
  cond = themeLib.isThemeActive config "guernica";
  profileName = "guernica";

  zenNebulaTheme = pkgs.stdenv.mkDerivation {
    name = "zen-nebula-theme";
    version = "git";
    src = pkgs.fetchFromGitHub {
      owner = "JustAdumbPrsn";
      repo = "Zen-Nebula";
      rev = "main";
      hash = "sha256-wtntRAkOGm6fr396kqzqk+GyPk+ytifXTqqOp0YIvlw=";
    };
    installPhase = ''
      mkdir -p $out
      cp -r $src/Nebula $out/
      cp -r $src/userChrome.css $out/
      cp -r $src/userContent.css $out/
    '';
  };

in
{
  stylix.targets.zen-browser = {
    enable = false; # disabled by default
    profileNames = [
      profileName
    ];
  };

  programs.zen-browser.profiles.${profileName} = themeLib.whenTheme config "guernica" {
    isDefault = true;
    settings = {

      # "font.name.monospace.x-western" = config.stylix.fonts.monospace.name;

      # Zen Settings ( stolen from:  github.com/LudovicoPiero/dotfiles  zen browser config )
      "browser.newtabpage.activity-stream.trendingSearch.defaultSearchEngine" = "DuckDuckGo";

      #"zen.widget.linux.transparency" = true;
      "zen.urlbar.behavior" = "float";
      "nebula-tab-loading-animation" = 0;
      "zen.tab-unloader.enabled" = true;
      "zen.tab-unloader.timeout-minutes" = 20;
      "zen.view.sidebar-expanded" = false;
      "zen.view.show-newtab-button-top" = false;
      "zen.welcome-screen.seen" = true;
      "zen.glance.open-essential-external-links" = false;

      "font.name.sans-serif.x-western" = config.stylix.fonts.sansSerif.name;
      "font.name.serif.x-western" = config.stylix.fonts.serif.name;
      "font.name.monospace.x-western" = config.stylix.fonts.monospace.name;

    };
    extensions.packages = with pkgs.nur.repos.rycee.firefox-addons; [
      ublock-origin
      refined-github
      enhanced-github
      foxyproxy-standard
      sponsorblock
      vimium
      to-deepl
      bonjourr-startpage
      search-by-image
    ];
  };

  home.file."zen-nebula" = themeLib.whenTheme config "guernica" {
    enable = cond;
    source = zenNebulaTheme;
    target = "${config.xdg.configHome}/zen/${profileName}/chrome";
    recursive = true;
  };

}
