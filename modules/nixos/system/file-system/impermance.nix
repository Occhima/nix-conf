{
  config,
  lib,
  inputs,
  ...
}:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.modules.system.file-system.impermanence;
in
{
  imports = [
    inputs.impermanence.nixosModules.impermanence
  ];

  options.modules.system.file-system.impermanence = {
    enable = mkEnableOption "impermanence for filesystems";
  };

  config = mkIf cfg.enable {

    environment.persistence."/persist" = {
      hideMounts = true;
      files = [
        "/etc/ssh/ssh_host_ed25519_key"
        "/etc/ssh/ssh_host_ed25519_key.pub"
        "/etc/ssh/ssh_host_rsa_key"
        "/etc/ssh/ssh_host_rsa_key.pub"
      ];
      directories = [ "/var/lib" ];
    };
  };
}
