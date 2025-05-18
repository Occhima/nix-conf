{
  config,
  lib,
  inputs,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.modules.nixgl;
in
{
  options.modules.nixgl = {
    enable = mkEnableOption "NixGL for running OpenGL applications";
  };

  # XXX: I need to use this bc of nvidia's TERRIBLE nix support
  # The downside is the impurity it adds
  config = mkIf cfg.enable {
    nixGL = {
      packages = inputs.nixgl.packages;
      defaultWrapper = "mesa";
      installScripts = [
        "mesa"
      ];
    };
  };
}
