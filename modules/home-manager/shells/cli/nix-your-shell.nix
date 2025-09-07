{
  lib,
  config,
  ...
}:

let
  inherit (lib) mkIf;
  cfg = config.modules.shell.cli;
in
{
  config = mkIf (cfg.enable && builtins.elem "nix-your-shell" cfg.tools) {
    programs.nix-your-shell = {
      enable = true;
    };
  };
}
