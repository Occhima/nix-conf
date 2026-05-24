{
  lib,
  config,
  pkgs,
  self,
  ...
}:
let
  inherit (lib) mkIf getExe;
  cfg = config.modules.shell.cli;
  pkg = self.packages.${pkgs.stdenv.hostPlatform.system}.codegraph;
in
{
  config = mkIf (cfg.enable && builtins.elem "codegraph" cfg.tools) {
    home.packages = [ pkg ];

    programs.mcp.servers.codegraph = {
      command = getExe pkg;
      args = [
        "serve"
        "--mcp"
      ];
      type = "stdio";
    };
  };
}
