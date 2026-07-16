{ ... }:
{
  config.flake.modules.homeManager.neovim = (
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
        nixvim.homeModules.nixvim
      ];

      options.modules.editor.neovim = {
        default = mkEnableOption "Use neovim as the default editor";
      };

      config = {
        home = {
          packages = [ self.packages.${pkgs.stdenv.hostPlatform.system}.nvim ];
          sessionVariables = mkIf cfg.default {
            EDITOR = "nvim";
          };
        };
      };
    }
  );
}
