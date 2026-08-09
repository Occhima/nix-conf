{

  nixpkgs.allowedUnfree = [
    "gitbutler"
  ];

  flake.modules.homeManager.gitbutler = { pkgs, ... }: {
    config = {
      home.packages = [
        pkgs.gitbutler
      ];
    };
  };
}
