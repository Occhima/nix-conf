{
  inputs,
  self,
  ...
}:
let
  hmLib = inputs.nixpkgs.lib.extend (_: _: { occhima = self.lib.occhima; });

  # Standalone-only context: values that integrated evaluations derive
  # from the real `osConfig` (see modules/home-manager/host-context.nix).
  standaloneContext = {
    modules.hostContext = {
      wayland = false;
      monitors = {
        primaryMonitorName = "dp1";
        displays.dp1 = {
          output = "DP-1";
          mode = "2560x1080@180";
          position = "0x0";
        };
      };
    };
  };
in
{
  imports = [ inputs.home-manager.flakeModules.home-manager ];

  # Standalone Home Manager for non-NixOS machines. NixOS hosts use the
  # integrated module (modules/nixos/accounts) as the primary path.
  flake.homeConfigurations.occhima = inputs.home-manager.lib.homeManagerConfiguration {
    pkgs = import inputs.nixpkgs {
      system = "x86_64-linux";
      overlays = builtins.attrValues self.overlays;
      config = {
        allowUnfree = true;
        allowBroken = false;
        allowUnsupportedSystem = false;
      };
    };

    lib = hmLib;

    modules = [
      ../../home/occhima
      self.modules.homeManager.default
      standaloneContext
    ];

    extraSpecialArgs = {
      inherit inputs self;
    };
  };
}
