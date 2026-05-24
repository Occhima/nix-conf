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
  pkg = self.packages.${pkgs.stdenv.hostPlatform.system}.agentmemory;
in
{
  config = mkIf (cfg.enable && builtins.elem "agentmemory" cfg.tools) {
    home.packages = [ pkg ];

    programs.mcp.servers.agentmemory = {
      command = getExe pkg;
      args = [ "mcp" ];
      type = "stdio";
      env = {
        AGENTMEMORY_URL = "http://localhost:3111";
        AGENTMEMORY_SECRET = "{env:AGENTMEMORY_SECRET}";
      };
    };
  };
}
