{
  config,
  pkgs,
  lib,
  ...

}:
let
  inherit (lib) mkIf;
  inherit (lib.occhima) hasProfile;
in
{
  config = mkIf (hasProfile config [ "web" ]) {
    home.packages = with pkgs; [
      pastel
      postman
    ];
  };
}
