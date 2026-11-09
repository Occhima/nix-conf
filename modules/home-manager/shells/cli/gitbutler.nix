{

  nixpkgs.allowedUnfree = [
    "gitbutler"
  ];

  flake.modules.homeManager.gitbutler = { pkgs, ... }: {
    config = {
      home.packages = [
        (
          (pkgs.gitbutler.override {
            turbo = pkgs.turbo.override {
              turbo-unwrapped = pkgs.turbo-unwrapped.overrideAttrs { dontCargoUseSystemLibs = true; };
            };
          }).overrideAttrs
          { dontCargoUseSystemLibs = true; }
        )
      ];
    };
  };
}
