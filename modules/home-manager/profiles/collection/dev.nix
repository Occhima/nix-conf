{
  pkgs,
  lib,
  config,
  ...
}:

let
  inherit (lib) mkIf;
  inherit (lib.custom) hasProfile;
in

{
  config = mkIf (hasProfile config [ "dev" ]) {
    home = {
      packages = [
        pkgs.devenv
        pkgs.comma
        pkgs.hyperfine
      ];
    };
  };

}
