{
  lib,
  pkgs,
  config,
  ...
}:
{
  options = {
    python = lib.mkOption {
      type = lib.types-custom.langCfgType;
    };
  };

  config =
    with lib;
    if config.python.enable or false then
      let
        cfg = config.python;
        python =
          assert assertMsg (hasAttr "package" cfg)
            "`python.package` must be specified and be a valid package when enabling Python environment.";
          cfg.package;

        # Load a uv workspace from a workspace root.
        # Uv2nix treats all uv projects as workspace projects.

      in
      # Create package overlay from workspace.
      {
        python = {
          extraPackages = [ pkgs.uv ];

          # [TODO] Requires more setup
          # Package a virtual environment as our main application.
          #
          # Enable no optional dependencies for production build.
          # packages.x86_64-linux.default = pythonSet.mkVirtualEnv builtins.toString ../../. workspace.deps.default;

          # Make hello runnable with `nix run`
          # apps.x86_64-linux = {
          #     default = {
          #         type = "app";
          #         program = "${self.packages.x86_64-linux.default}/bin/hello";
          #     };
          # };

          # This devShell simply adds Python and undoes the dependency leakage done by Nixpkgs Python infrastructure.
          env =
            {
              # Prevent uv from managing Python downloads
              UV_PYTHON_DOWNLOADS = "never";
              # Force uv to use nixpkgs Python interpreter
              UV_PYTHON = python.interpreter;
            }
            // lib.optionalAttrs pkgs.stdenv.isLinux {
              # Python libraries often load native shared objects using dlopen(3).
              # Setting LD_LIBRARY_PATH makes the dynamic library loader aware of libraries without using RPATH for lookup.
              LD_LIBRARY_PATH = lib.makeLibraryPath pkgs.pythonManylinuxPackages.manylinux1;
            }
            // cfg.env or { };

          shellHook =
            ''
              unset PYTHONPATH
            ''
            + cfg.shellHook or "";
        };
      }
    else
      {
        python = {
          package = mkForce null;
          extraPackages = mkForce [ ];
          env = mkForce { };
          shellHook = mkForce "";
        };
      };
}
