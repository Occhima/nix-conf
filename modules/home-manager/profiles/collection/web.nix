{
  config,
  self,
  pkgs,
  lib,
  ...

}:
let
  inherit (lib) mkIf;
  inherit (self.lib.custom) hasProfile;
in
{
  config = mkIf (hasProfile config [ "web" ]) {
    home.packages = with pkgs; [
      pastel
    ];
  };
}
