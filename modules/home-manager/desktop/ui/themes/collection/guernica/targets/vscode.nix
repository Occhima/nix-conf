{
  config,
  lib,
  ...
}:

let
  inherit (lib.custom) themeLib;
in
{
  stylix.targets.vscode.enable = themeLib.whenTheme config "guernica" true;
}
