{ lib, ... }:
let
  inherit (lib) mkOption types;
in
{
  # Top-level namespace for this configuration. Host specifications are
  # data: identity and machine facts, never reusable feature modules.
  options.occhima.hosts = mkOption {
    description = ''
      Typed host registry. Each entry is loaded from
      `hosts/<name>/default.nix` and turned into a `nixosConfigurations`
      output by the host builder.
    '';
    default = { };
    type = types.attrsOf (
      types.submodule {
        options = {
          system = mkOption {
            type = types.enum [
              "x86_64-linux"
              "aarch64-linux"
            ];
            default = "x86_64-linux";
            description = "Platform the host runs on.";
          };

          class = mkOption {
            type = types.enum [
              "nixos"
              "iso"
            ];
            default = "nixos";
            description = ''
              Which root module the host is built from: `nixos` for
              ordinary machines (WSL machines select the `wsl` profile),
              `iso` for installer images.
            '';
          };

          stateVersion = mkOption {
            type = types.nullOr types.str;
            default = null;
            description = ''
              Value for `system.stateVersion`. Required for `nixos` hosts;
              leave null for ISO images. Never upgrade this for an existing
              installation.
            '';
          };

          profiles = mkOption {
            type = types.listOf types.str;
            default = [ ];
            description = ''
              Profiles to activate (`modules.profiles.active`). Names are
              validated against the profile enum when the host is
              evaluated.
            '';
          };

          deployable = mkOption {
            type = types.bool;
            default = false;
            description = "Whether deploy-rs should manage this host.";
          };

          modules = mkOption {
            type = types.listOf types.deferredModule;
            default = [ ];
            description = ''
              Machine-specific NixOS modules (configuration, hardware,
              disko). Reusable features are not listed here — they are
              enabled through options.
            '';
          };
        };
      }
    );
  };
}
