# NOTE: Stolen from: https://github.com/s3igo/dotfiles/blob/82929b20af8f66acfbbc41a614fbfbb9de1385e6/home/aider.nix#L4
{
  lib,
  config,
  pkgs,
  self,
  ...
}:

let
  inherit (lib) mkIf;
  inherit (self.lib.custom) hasProfile;
in

{
  config = mkIf (hasProfile config [ "data" ]) {
    home = {
      packages = [
        (pkgs.rustPlatform.buildRustPackage rec {
          pname = "xleak";
          version = "0.2.5";

          src = pkgs.fetchFromGitHub {
            owner = "bgreenwell";
            repo = "xleak";
            rev = "v${version}";
            hash = "sha256-5amFyNI1cfTu9b5PV7/n4XIXZbFoSnaTyZo7oPpDQL4=";
          };

          cargoLock = {
            lockFile = "${src}/Cargo.lock";
          };

          doCheck = false;

          meta = with pkgs.lib; {
            description = "Terminal Excel viewer with interactive TUI, search, formulas, and export";
            homepage = "https://github.com/bgreenwell/xleak";
            license = licenses.mit;
            platforms = platforms.all;
          };
        })

      ];
    };
  };
}
