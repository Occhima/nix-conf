{
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
      mkdir $out
      cp -r $src/Nebula $out/
      cp -r $src/userChrome.css $out/
      cp -r $src/userContent.css $out/
    '';
  };

in
{
  # checking the config multiple times, maysbe pass cond variable as input?
  stylix.targets.zen-browser = mkIf cond {
    enable = false;
    profileNames = [
      profileName
    ];
  };

  programs.zen-browser.profiles.guernica = mkIf cond {
    isDefault = true;
    extensions.packages = with pkgs.nur.repos.rycee.firefox-addons; [
      ublock-origin
      refined-github
      enhanced-github
      vimium
      foxyproxy-standard
      bonjourr-startpage
    ];
  };
  home.file."zen-nebula" = mkIf cond {

    enable = cond;
    source = zenNebulaTheme;
    target = "${config.xdg.configHome}/${profileName}/chrome";
    recursive = true;
  };

}
