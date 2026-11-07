# Host inventory: declarative wiring of hosts to their users. The aspects of
# the same names (modules/den/aspects/) provide the actual configuration.
{ config, inputs, ... }:
{
  den.hosts.aarch64-linux.phone = {
    class = "nixOnDroid";
    intoAttr = [
      "nixOnDroidConfigurations"
      "phone"
    ];
    instantiate =
      { modules, ... }:
      inputs.nix-on-droid.lib.nixOnDroidConfiguration {
        modules = builtins.filter (m: !(builtins.isAttrs m && m ? nixpkgs.hostPlatform)) modules;
        pkgs = config.flake.lib.custom.mkPkgs {
          system = "aarch64-linux";
          overlays = [ inputs.nix-on-droid.overlays.default ];
        };
      };
  };

  den.hosts.x86_64-linux = {
    aerodynamic.users.occhima = { };
    beyond.users.occhima = { };
    crescendoll = {
      wsl.enable = true;
      users.occhima = { };
    };
    steammachine.users.occhima = { };
    # Installer ISO builder — no regular user.
    voyager = { };
  };
}
