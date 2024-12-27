{
  pkgs,
  config,
  ...
}: {
  default = pkgs.mkShell {
    buildInputs = with pkgs; [
      git
      home-manager
      nix
      just
    ];

    shellHook = ''
      ${config.pre-commit.installationScript}
    '';
  };
}
