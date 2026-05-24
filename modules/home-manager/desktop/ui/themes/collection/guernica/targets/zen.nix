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
      hash = "sha256-1jZ+7ndp31qTGreStonmSz97zulA48fTR+0g/Zqw0UI=";
    };

    installPhase =
      #bash
      ''
        mkdir -p $out
        cp -r $src/nebula/. $out/
        mv $out/chrome.css $out/userChrome.css
        mv $out/content.css $out/userContent.css
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
    path = profileName;
    settings = {

      # "font.name.monospace.x-western" = config.stylix.fonts.monospace.name;

      # Zen Settings ( stolen from:  github.com/LudovicoPiero/dotfiles  zen browser config )
      "browser.newtabpage.activity-stream.trendingSearch.defaultSearchEngine" = "DuckDuckGo";
      "browser.tabs.allow_transparent_browser" = true;

      #"zen.widget.linux.transparency" = true;
      "zen.urlbar.behavior" = "float";
      "nebula-tab-loading-animation" = 0;
      "zen.tab-unloader.enabled" = true;
      "zen.tab-unloader.timeout-minutes" = 20;
      "zen.view.sidebar-expanded" = false;
      "zen.view.show-newtab-button-top" = false;
      "zen.welcome-screen.seen" = true;
      "zen.glance.open-essential-external-links" = false;

      "toolkit.legacyUserProfileCustomizations.stylesheets" = true;

      # Dark mode
      "browser.display.background_color.dark" = "#1C1B22";
      "browser.display.foreground_color.dark" = "#FBFBFE";
      "browser.active_color.dark" = "#FF6666";
      "browser.anchor_color.dark" = "#00CADB";
      "browser.visited_color.dark" = "#FFADFF";
      "browser.theme.dark-private-windows" = true;
      "extensions.webextensions.pageActionIconDarkModeFilter.enabled" = true;
      "layout.css.accent-color.darkening-target-contrast-ratio" = 6.0;
      "layout.css.light-dark-images.enabled" = true;
      "widget.disable-dark-scrollbar" = false;
      "widget.non-native-theme.scrollbar.dark-themed" = true;
      "zen.theme.dark-mode-bias" = 0.3;

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
      zen-internet
    ];
  };

  home.file."zen-nebula" = themeLib.whenTheme config "guernica" {
    enable = cond;
    source = zenNebulaTheme;
    target = "${config.home.homeDirectory}/.zen/${profileName}/chrome";
    recursive = true;
  };

}
