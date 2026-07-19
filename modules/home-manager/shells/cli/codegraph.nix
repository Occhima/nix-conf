{ config, ... }:
let
  flakePkgs = config.flake.packages;
in
{
  flake.modules.homeManager.codegraph =
    {
      lib,
      pkgs,
      ...
    }:
    let
      inherit (lib) getExe;
      pkg = flakePkgs.${pkgs.stdenv.hostPlatform.system}.codegraph;
    in
    {
      config = {
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
    };
}
