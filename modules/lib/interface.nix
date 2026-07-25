# `flake.lib` — repository helper namespace.
#
# Declared as a merging option so that independent top-level modules can
# each contribute helpers to `flake.lib.custom.*`; consumers capture them
# from the fixed point:
#
#   { config, ... }:
#   let inherit (config.flake.lib.custom) isWayland; in ...
{
  lib,
  flake-parts-lib,
  ...
}:
{
  options.flake = flake-parts-lib.mkSubmoduleOptions {
    lib = lib.mkOption {
      type = lib.types.lazyAttrsOf (lib.types.lazyAttrsOf lib.types.raw);
      default = { };
      description = "Namespaced helper functions exported by this flake.";
    };
  };
}
