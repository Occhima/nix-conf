# flake-parts does not declare `flake.templates`; declare it once so each
# template file can contribute its own entry.
{
  lib,
  flake-parts-lib,
  ...
}:
{
  options.flake = flake-parts-lib.mkSubmoduleOptions {
    templates = lib.mkOption {
      type = lib.types.lazyAttrsOf (
        lib.types.submodule {
          options = {
            path = lib.mkOption { type = lib.types.path; };
            description = lib.mkOption { type = lib.types.str; };
          };
        }
      );
      default = { };
      description = "Flake templates.";
    };
  };
}
