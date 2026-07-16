{ lib, ... }:
let
  inherit (lib.custom)
    isWayland
    ifTheyExist
    isPackageEnabled
    ifPackageNotEnabled
    ;
in
{
  "isWayland is true for a wayland display stack" = {
    expr = isWayland { modules.system.display.type = "wayland"; };
    expected = true;
  };
  "isWayland is false for x11" = {
    expr = isWayland { modules.system.display.type = "x11"; };
    expected = false;
  };
  "isWayland is false when the display fact is absent" = {
    expr = isWayland { };
    expected = false;
  };

  "ifTheyExist keeps only existing groups" = {
    expr = ifTheyExist {
      users.groups = {
        wheel = { };
        audio = { };
      };
    } [ "wheel" "docker" "audio" ];
    expected = [
      "wheel"
      "audio"
    ];
  };

  "isPackageEnabled true for enabled program" = {
    expr = isPackageEnabled { programs.git.enable = true; } "git";
    expected = true;
  };
  "isPackageEnabled false for unknown program" = {
    expr = isPackageEnabled { programs = { }; } "git";
    expected = false;
  };

  "ifPackageNotEnabled filters programs enabled in either config" = {
    expr = ifPackageNotEnabled { programs.git.enable = true; } { programs.vim.enable = true; } [
      "git"
      "vim"
      "htop"
    ];
    expected = [ "htop" ];
  };
}
