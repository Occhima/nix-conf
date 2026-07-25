# Host: aerodynamic — laptop, Intel/NVIDIA, Greetd, Disko, impermanence.
# Plain deferred NixOS module; usable without Den.
{ config, ... }: {
  flake.modules.nixos.host-aerodynamic = {
    imports = with config.flake.modules.nixos; [
      workstation
      cpu-intel
      gpu-nvidia
      login-greetd
      disko-aerodynamic
      laptop
    ];

    modules.network.hostName = "aerodynamic";

    # agenix-rekey host identity lives next to the host, not in a registry.
    age.rekey.hostPubkey = builtins.readFile ./host.pub;

    modules.hardware.monitors = {
      primaryMonitorName = "edp1";
      displays.edp1 = {
        output = "eDP-1";
        width = 2560;
        height = 1080;
        refreshRate = 180;
        x = 0;
        y = 0;
      };
    };
    modules.system.boot.loader.grub.device = "/dev/nvme0n1";
  };
}
