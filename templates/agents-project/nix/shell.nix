{ ... }:
{
  perSystem =
    {
      config,
      pkgs,
      ...
    }:
    let

      # add your packages her
      commonPackages = [
      ];

      hook = ''
        codegraph sync
        rtk init -g
      '';
    in
    {
      devShells.default = pkgs.mkShell {
        inputsFrom = [ config.treefmt.build.devShell ];
        name = "monorepo";
        packages = commonPackages;
        shellHook = hook;

        env = {
        };
      };
    };
}
