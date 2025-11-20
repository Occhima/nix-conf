{
  config,
  self,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.modules.editor.neovim;

in
{

  options.modules.editor.antigravity = {
    enable = mkEnableOption "Google antigravity agentic code editor";
  };

  config = mkIf cfg.enable {
    home = {
      packages = [ self.packages.${pkgs.stdenv.hostPlatform.system}.antigravity ];
    };
  };
}
