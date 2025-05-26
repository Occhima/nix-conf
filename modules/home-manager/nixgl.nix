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
