{
  flake-file.inputs.nix-on-droid = {
    url = "github:nix-community/nix-on-droid";
    inputs.nixpkgs.follows = "nixpkgs";
    inputs.home-manager.follows = "home-manager";
  };

  flake.modules.nixOnDroid.droid-base =
    { pkgs, ... }:
    {
      system.stateVersion = "24.05";

      nix.extraOptions = ''
        experimental-features = nix-command flakes
      '';

      time.timeZone = "America/Sao_Paulo";

      user.shell = "${pkgs.zsh}/bin/zsh";

      environment.packages = with pkgs; [
        git
        openssh
        procps
        gnugrep
        gnused
        gnutar
        gzip
        unzip
        which
        hostname
      ];
    };
}
