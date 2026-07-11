{
  pkgs,
  lib,
  config,
  ...
}:

let
  inherit (lib) mkIf;
  inherit (lib.occhima) hasProfile;
in

{
  config = mkIf (hasProfile config [ "dev" ]) {
    home = {
      packages = [
        # FIXME: Broken
        # pkgs.devenv
        pkgs.comma
        pkgs.hyperfine
      ];
    };
  };

}
