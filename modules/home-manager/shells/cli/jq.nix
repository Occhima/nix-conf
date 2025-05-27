{

  lib,

  config,
  pkgs,
  ...
}:

let
  inherit (lib) mkIf;
  cfg = config.modules.shell.cli;
in
{
  config = mkIf (cfg.enable && builtins.elem "jq" cfg.tools) {
    home.packages = [
      pkgs.jq-lsp
      pkgs.jql
    ];
    programs.jq = {
      enable = true;
    };
    programs.jqp = {
      enable = true;
    };
  };
}
