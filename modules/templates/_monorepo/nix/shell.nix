{ ... }:
{
  perSystem =
    {
      config,
      pkgs,
      ...
    }:
    let
      python = pkgs.python312;
      uv = pkgs.uv;
      commonPackages = [
        uv
        python
        pkgs.nil
        pkgs.marimo
      ];

      uvSync = ''
        if [ -s coding/python/pyproject.toml ]; then
          echo "Synchronizing Python dependencies with uv..."
          uv sync --directory coding/python --all-groups
        fi

        ${config.pre-commit.installationScript}
      '';
    in
    {
      devShells.default = pkgs.mkShell {
        inputsFrom = [ config.treefmt.build.devShell ];
        name = "monorepo";
        packages = commonPackages;
        shellHook = uvSync;

        env = {
          UV_PYTHON_PREFERENCE = "only-managed";
          PYTHONDONTWRITEBYTECODE = "1";
        };
      };
    };
}
