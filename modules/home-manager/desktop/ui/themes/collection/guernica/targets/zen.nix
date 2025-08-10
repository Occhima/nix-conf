{
  # TODO  Inject profile name?
  config,
  lib,
  pkgs,
  ...
}:
let

  inherit (lib) mkIf;
  cfg = config.modules.desktop.ui.themes;
  cond = (cfg.enable && cfg.name == "guernica");
  profileName = "guernica";

  zenNebulaTheme = pkgs.stdenv.mkDerivation {
    name = "zen-nebula-theme";
    version = "git";
    src = pkgs.fetchFromGitHub {
      owner = "JustAdumbPrsn";
      repo = "Zen-Nebula";
      rev = "a9bf56f9d3b8e07c691cc3731fdd6ec53c18b8d3";
      hash = "sha256-ov5Ix10K0YWtwEpK6hRhsISheJKDunGTO4e8jqE5Ry8=";
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
  # checking the config multiple times, maysbe pass cond variable as input?
  stylix.targets.zen-browser = {
    enable = !cond; # disabled by default
    # profileNames = [
    #   profileName
    # ];
  };

  programs.zen-browser.profiles.guernica = mkIf cond {
    id = 0;
    isDefault = true;
    settings = {

      # "font.name.monospace.x-western" = config.stylix.fonts.monospace.name;

      # Zen Settings ( stolen from:  github.com/LudovicoPiero/dotfiles  zen browser config )
      "zen.tab-unloader.enabled" = true;
      "zen.tab-unloader.timeout-minutes" = 20;
      "zen.view.sidebar-expanded" = false;
      "zen.view.show-newtab-button-top" = false;
      "zen.welcome-screen.seen" = true;
      "zen.glance.open-essential-external-links" = false;
      "browser.tabs.allow_transparent_browser" = true;

      # for zen userChrome and userCss extras
      "toolkit.legacyUserProfileCustomizations.stylesheets" = true;

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

  home.file."zen-nebula" = mkIf cond {
    enable = cond;
    source = zenNebulaTheme;
    target = ".zen/${profileName}/chrome";
    recursive = true;
  };

}
