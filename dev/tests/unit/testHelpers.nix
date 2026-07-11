{ lib, ... }:
let
  inherit (lib.occhima)
    isPackageEnabled
    ifPackageNotEnabled
    ifTheyExist
    isWayland
    hasProfile
    ;
in
{
  "test ifTheyExist keeps only existing groups" = {
    expr =
      ifTheyExist
        {
          users.groups = {
            wheel = { };
            docker = { };
          };
        }
        [
          "wheel"
          "audio"
          "docker"
        ];
    expected = [
      "wheel"
      "docker"
    ];
  };

  "test hasProfile matches any active profile" = {
    expr =
      hasProfile
        {
          modules.profiles.active = [
            "desktop"
            "graphical"
          ];
        }
        [
          "graphical"
          "laptop"
        ];
    expected = true;
  };

  "test hasProfile with no match" = {
    expr = hasProfile { modules.profiles.active = [ "wsl" ]; } [ "graphical" ];
    expected = false;
  };

  #####################################################################
  # Tests for isPackageEnabled
  #####################################################################

  "test isPackageEnabled with enabled package" = {
    expr = isPackageEnabled {
      programs.git = {
        enable = true;
      };
    } "git";
    expected = true;
  };

  "test isPackageEnabled with disabled package" = {
    expr = isPackageEnabled {
      programs.git = {
        enable = false;
      };
    } "git";
    expected = false;
  };

  "test isPackageEnabled with non-existent package" = {
    expr = isPackageEnabled { programs = { }; } "nonexistent";
    expected = false;
  };

  #####################################################################
  # Tests for ifPackageNotEnabled
  #####################################################################

  "test ifPackageNotEnabled with all packages enabled in config" = {
    expr =
      ifPackageNotEnabled
        {
          programs.git = {
            enable = true;
          };
          programs.vim = {
            enable = true;
          };
        }
        { programs = { }; }
        [
          "git"
          "vim"
          "nvim"
        ];
    expected = [ "nvim" ];
  };

  "test ifPackageNotEnabled with some packages enabled in osConfig" = {
    expr =
      ifPackageNotEnabled
        {
          programs.git = {
            enable = true;
          };
        }
        {
          programs.vim = {
            enable = true;
          };
        }
        [
          "git"
          "vim"
          "nvim"
        ];
    expected = [ "nvim" ];
  };

  "test ifPackageNotEnabled with no packages enabled" = {
    expr = ifPackageNotEnabled { programs = { }; } { programs = { }; } [
      "git"
      "vim"
      "nvim"
    ];
    expected = [
      "git"
      "vim"
      "nvim"
    ];
  };

  #####################################################################
  # Tests for isWayland
  #####################################################################

  "test isWayland with wayland display type" = {
    expr = isWayland {
      modules.system.display.type = "wayland";
    };
    expected = true;
  };

  "test isWayland with x11 display type" = {
    expr = isWayland {
      modules.system.display.type = "x11";
    };
    expected = false;
  };

  "test isWayland with empty display type" = {
    expr = isWayland {
      modules.system.display.type = "";
    };
    expected = false;
  };

  "test isWayland with missing display type" = {
    expr = isWayland {
      modules.system = { };
    };
    expected = false;
  };

  "test isWayland with completely empty config" = {
    expr = isWayland { };
    expected = false;
  };

}
