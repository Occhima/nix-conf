{
  inputs,
  config,
  self,
  lib,
  pkgs,
  ...
}:
let
  inherit (inputs) nixvim;
  inherit (lib) mkEnableOption mkIf;
  cfg = config.modules.editor.neovim;

in
{
  imports = [
    nixvim.homeManagerModules.nixvim
  ];

  options.modules.editor.neovim = {
    enable = mkEnableOption "Neovim editor (powered by nixvim)";
    default = mkEnableOption "Use neovim as the default editor";
  };

  config = mkIf cfg.enable {
    home = {
      packages = [ self.packages.${pkgs.system}.nvim ];
      sessionVariables = {
        EDITOR = "nvim";
        VISUAL = "nvim";
      };
    };
  };
}
