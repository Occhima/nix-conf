{
  config,
  pkgs,
  lib,
  ...

}:
let
  inherit (lib) mkIf;
  inherit (lib.custom) hasProfile;
in
{
  config = mkIf (hasProfile config [ "web" ]) {
    home.packages = with pkgs; [
      pastel
      postman
    ];
  };
}
