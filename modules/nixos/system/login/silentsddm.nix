# SDDM + Silent theme (github.com/uiriansan/SilentSDDM), retinted with the
# polykai palette from the guernica home theme:
# modules/home-manager/desktop/ui/themes/collection/guernica/colors.nix
{ inputs, ... }:
let
  polykai = {
    bg = "#141818"; # base00
    bg-light = "#1e2424"; # base01
    border = "#3c4848"; # base02
    muted = "#909090"; # base03
    fg = "#f8f8f8"; # base05
    accent = "#c080ff"; # base0C purple
    warn = "#ffb000"; # base08
    err = "#ff0060"; # base0E
  };
in
{
  flake-file.inputs.silentSDDM = {
    url = "github:uiriansan/SilentSDDM";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  flake.modules.nixos.login-silentsddm =
    { pkgs, ... }:
    let
      # Same wallpaper the reGreet module used.
      wallpaper = pkgs.nixos-artwork.wallpapers.nineish-dark-gray.gnomeFilePath;
    in
    {
      imports = [ inputs.silentSDDM.nixosModules.default ];

      config.programs.silentSDDM = {
        enable = true;
        theme = "default";
        backgrounds.nineish = wallpaper;

        # ponytail: only the visible surfaces are tinted; add more sections
        # from the wiki (200+ options) if something still looks stock.
        settings = {
          "LoginScreen" = {
            background = "nineish";
            blur = 10;
          };
          "LockScreen" = {
            background = "nineish";
            blur = 10;
          };
          "LoginScreen.Clock" = {
            format = "hh:mm";
            color = polykai.fg;
          };
          "LoginScreen.Date".color = polykai.muted;
          "LoginScreen.LoginArea.Avatar" = {
            active-border-color = polykai.accent;
            inactive-border-color = polykai.border;
          };
          "LoginScreen.LoginArea.Username".color = polykai.fg;
          "LoginScreen.LoginArea.PasswordInput" = {
            content-color = polykai.fg;
            background-color = polykai.bg;
            background-opacity = 0.85;
            border-color = polykai.border;
            border-radius-left = 12;
            border-radius-right = 12;
            width = 280;
          };
          "LoginScreen.LoginArea.LoginButton" = {
            background-color = polykai.bg;
            background-opacity = 0.85;
            content-color = polykai.fg;
            active-background-color = polykai.accent;
            active-content-color = polykai.bg;
            border-color = polykai.border;
            border-radius-left = 12;
            border-radius-right = 12;
          };
          "LoginScreen.LoginArea.WarningMessage" = {
            normal-color = polykai.muted;
            warning-color = polykai.warn;
            error-color = polykai.err;
          };
          "LoginScreen.MenuArea.Popups" = {
            background-color = polykai.bg;
            background-opacity = 0.9;
            content-color = polykai.fg;
            active-option-background-color = polykai.accent;
            active-option-background-opacity = 1.0;
            active-content-color = polykai.bg;
            border-color = polykai.border;
            border-size = 1;
          };
          "LoginScreen.MenuArea.Session" = {
            background-color = polykai.bg;
            background-opacity = 0.85;
            content-color = polykai.fg;
            active-background-color = polykai.accent;
            active-content-color = polykai.bg;
          };
          "LoginScreen.MenuArea.Power" = {
            background-color = polykai.bg;
            background-opacity = 0.85;
            content-color = polykai.fg;
            active-background-color = polykai.accent;
            active-content-color = polykai.bg;
          };
          "LoginScreen.MenuArea.Keyboard" = {
            background-color = polykai.bg;
            background-opacity = 0.85;
            content-color = polykai.fg;
            active-background-color = polykai.accent;
            active-content-color = polykai.bg;
          };
          "LoginScreen.VirtualKeyboard" = {
            background-color = polykai.bg;
            background-opacity = 0.9;
            key-color = polykai.bg-light;
            key-opacity = 0.9;
            key-content-color = polykai.fg;
            key-active-background-color = polykai.accent;
            selection-background-color = polykai.accent;
            primary-color = polykai.bg;
            border-color = polykai.border;
          };
        };
      };
    };
}
