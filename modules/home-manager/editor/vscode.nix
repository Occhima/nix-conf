{
  flake.modules.homeManager.vscode = { pkgs, ... }: {
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
  };
}
