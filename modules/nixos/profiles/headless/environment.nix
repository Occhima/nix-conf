{
  lib,
  config,
  ...
}:
let
  inherit (lib) mkIf;
  inherit (lib.occhima) hasProfile;
in
{
  config = mkIf (hasProfile config [ "headless" ]) {
    environment.variables.BROWSER = "echo";
  };
}
