# NOTE: Stolen from: https://github.com/s3igo/dotfiles/blob/82929b20af8f66acfbbc41a614fbfbb9de1385e6/home/aider.nix#L4
{
  pkgs,
  lib,
  config,
  self,
  ...
}:

let
  inherit (lib) mkIf;
  inherit (self.lib.custom) hasProfile;
in

{
  config = mkIf (hasProfile config [ "dev" ]) {
    home = {
      packages = [
        pkgs.devenv
      ];
    };
  };

}
