{ ... }:
{
  config.flake.modules.homeManager.codegraph = (
    {
      lib,
      config,
      pkgs,
      self,
      ...
    }:
    let
      inherit (lib) getExe;
      pkg = self.packages.${pkgs.stdenv.hostPlatform.system}.codegraph;
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
    }
  );
}
