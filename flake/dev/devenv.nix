{ inputs, ... }:
{
  imports = [
    inputs.devenv.flakeModule
  ];

  perSystem =
    {
      config,
      lib,
      pkgs,
      inputs',
      self',
      ...
    }:

    let
      inherit (self'.packages) install-tools;
      nixConfig = builtins.toFile "nix.conf" ''
        warn-dirty = false
        http2 = true
        experimental-features = nix-command flakes pipe-operators
        use-xdg-base-directories = true
      '';

      nix-unit = inputs'.nix-unit.packages.default;
      namaka = inputs'.namaka.packages.default;
      deploy-rs = inputs'.deploy-rs.packages.deploy-rs; # remote deployment
      nix-search-tv = inputs'.nix-search-tv.packages.default;

    in

    {
      devenv = {
        shells.default = {
          name = "nixos-config-dev";
          env = {
            NIX_USER_CONF_FILES = nixConfig;
            FLAKE = ".";
            NH_FLAKE = ".";
            AGENIX_REKEY_ADD_TO_GIT = "true";
          };
          languages.nix.enable = true;
          packages =
            with pkgs;
            [
              direnv
              gitAndTools.hub
              namaka
              just
              nix-unit
              nix-search-tv
              config.formatter
              install-tools
            ]
            ++ lib.lists.optionals pkgs.stdenv.hostPlatform.isLinux [ deploy-rs ];
          enterShell = config.pre-commit.installationScript;
          scripts = {
            quit.exec = "exit";
            onefetch.exec = "onefetch";
            agenix.exec = "${config.agenix-rekey.package}/bin/agenix";
            tv.exec = "nix-search-tv print | fzf --preview 'nix-search-tv preview {}' --scheme history";
          };
        };
      };
    };
}
