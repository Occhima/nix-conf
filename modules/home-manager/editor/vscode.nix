{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.modules.editor.vscodium;

in
{

  options.modules.editor.vscodium = {
    enable = mkEnableOption "VSCodium editor (powered by nixvim)";
    default = mkEnableOption "Use vscode as the default editor";
  };

  config = mkIf cfg.enable {
    programs.vscode = {
      enable = true;
      package = pkgs.vscodium;
      profiles.default = {
        extensions = with pkgs.vscode-extensions; [
          editorconfig.editorconfig
          eamodio.gitlens
          esbenp.prettier-vscode
          dbaeumer.vscode-eslint
          vscodevim.vim
          yoavbls.pretty-ts-errors
        ];

        userSettings = {
          "window.menuBarVisibility" = "toggle";
          "editor.minimap.enabled" = false;
          "editor.renderWhitespace" = "trailing";
          "editor.cursorStyle" = "underline";
          "editor.lineNumbers" = "relative";
          "editor.wordWrap" = "on";
        };
      };
    };
    home = {
      sessionVariables = mkIf cfg.default {
        EDITOR = "vscode";
      };
    };
  };
}
