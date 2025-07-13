{
  lib,
  config,
  inputs,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    mkIf
    ;
  cfg = config.modules.virtualisation.microvm;

in
{
  options.modules.virtualisation.microvm = {
    enable = mkEnableOption "microvm configs";
  };

  imports = [ inputs.microvm.nixosModules.host ];

  config = mkIf cfg.enable {

  };
}
