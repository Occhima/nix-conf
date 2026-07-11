{
  config,
  lib,
  ...
}:

let
  inherit (lib.occhima) themeLib;
in
{
  stylix.targets.vscode.enable = themeLib.whenTheme config "guernica" true;
}
