{
  lib,
  config,
  pkgs,
  self,
  ...
}:
let
  inherit (lib) mkIf;
  cfg = config.modules.shell.cli;
  pkg = self.packages.${pkgs.stdenv.hostPlatform.system}.feynman;
in
{
  config = mkIf (cfg.enable && builtins.elem "feynman" cfg.tools) {
    home.packages = [ pkg ];
  };
}
