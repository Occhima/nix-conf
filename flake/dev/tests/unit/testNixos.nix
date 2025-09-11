{ lib, ... }:
let
  inherit (lib.custom)
    attrsToList
    mapModulesRec
    collectNixModulePaths
    filterNixFiles
    filterIgnoreModules
    isPackageEnabled
    ifPackageNotEnabled
    isWayland
    getShellFromConfig
    ;
in
{
  "test attrsToList with non-empty attributes" = {
    expr = attrsToList {
      a = 1;
      b = 2;
    };
    expected = [
      {
        name = "a";
        value = 1;
      }
      {
        name = "b";
        value = 2;
      }
    ];
  };

  "test attrsToList with empty attributes" = {
    expr = attrsToList { };
    expected = [ ];
  };

  # "test mapFilterAttrs with predicate and function" = {
  #   expr = mapFilterAttrs (name: _: name != "b") (name: value: value * 2) {
  #     a = "a";
  #     b = "b";
  #     c = "c";
  #   };
  #   expected = {
  #     a = "a";
  #     c = "c";
  #   };
  # };

  "test mapModulesRec with empty directory" = {
    expr = mapModulesRec ./fixtures/empty-dir import;
    expected = { };
  };

  "test mapModulesRec with directory and excludes" = {
    expr = mapModulesRec ./fixtures/empty-dir import;
    expected = { };
  };
  "test filterNixFiles filters only .nix files" = {
    expr = filterNixFiles [
      "foo.nix"
      "bar.txt"
      "baz.nix"
      "README.md"
    ];
    expected = [
      "foo.nix"
      "baz.nix"
    ];
  };

  "test filterNixFiles with empty input" = {
    expr = filterNixFiles [ ];
    expected = [ ];
  };

  #####################################################################
  # Tests for collectNixModulePaths
  #####################################################################

  # Assuming that ./fixtures/empty-dir is an empty directory.
  "test collectNixModulePaths with empty directory" = {
    expr = collectNixModulePaths ./fixtures/empty-dir;
    expected = [ ];
  };

  #####################################################################
  # Tests for filterIgnoreModules
  #####################################################################

  "test filterIgnoreModules with no flag" = {
    expr = filterIgnoreModules [
      "/test/dir1/file1.nix"
      "/test/dir2/file2.nix"
      "/test/dir3/file3.nix"
    ];

    expected = [
      "/test/dir1/file1.nix"
      "/test/dir2/file2.nix"
      "/test/dir3/file3.nix"
    ];
  };

  "test filterIgnoreModules with empty input" = {
    expr = filterIgnoreModules [ ];
    expected = [ ];
  };

  "test filterIgnoreModules with flag" = {
    expr = filterIgnoreModules [
      "/test/dir1/file1.nix"
      "/test/dir2/file2.nix"
      "/test/dir3/file3.nix"
      "/test/dir4/.moduleIgnore"
      "/test/dir4/file1.nix"
      "/test/dir4/file2.nix"
      "/test/dir4/dir5/file.nix"
      "/test/dir4/a/b/c/file.nix"
      "/test/a/b/c/d/.moduleIgnore"
      "/test/a/b/c/d/test.nix"
      "/test/a/b/c/test.nix"
    ];

    expected = [
      "/test/dir1/file1.nix"
      "/test/dir2/file2.nix"
      "/test/dir3/file3.nix"
      "/test/a/b/c/test.nix"
    ];
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

  #####################################################################
  # Tests for getShellFromConfig
  #####################################################################

  "test getShellFromConfig with valid user and shell" = {
    expr = getShellFromConfig {
      users.users.alice = {
        shell = {
          name = "bash";
        };
      };
    } "alice";
    expected = "bash";
  };

  "test getShellFromConfig with valid user and zsh shell" = {
    expr = getShellFromConfig {
      users.users.bob = {
        shell = {
          name = "zsh";
        };
      };
    } "bob";
    expected = "zsh";
  };

  "test getShellFromConfig with valid user and fish shell" = {
    expr = getShellFromConfig {
      users.users.charlie = {
        shell = {
          name = "fish";
        };
      };
    } "charlie";
    expected = "fish";
  };

  "test getShellFromConfig with non-existent user" = {
    expr = getShellFromConfig {
      users.users.alice = {
        shell = {
          name = "bash";
        };
      };
    } "nonexistent";
    expected = "";
  };

  "test getShellFromConfig with user but no shell" = {
    expr = getShellFromConfig {
      users.users.alice = {
        home = "/home/alice";
      };
    } "alice";
    expected = "";
  };

  "test getShellFromConfig with empty config" = {
    expr = getShellFromConfig { } "alice";
    expected = "";
  };

  "test getShellFromConfig with empty users section" = {
    expr = getShellFromConfig {
      users = { };
    } "alice";
    expected = "";
  };

  "test getShellFromConfig with multiple users" = {
    expr = getShellFromConfig {
      users.users = {
        alice = {
          shell = {
            name = "bash";
          };
        };
        bob = {
          shell = {
            name = "zsh";
          };
        };
      };
    } "bob";
    expected = "zsh";
  };
}
