{
  nixpkgs.allowedUnfree = [
    "postman"
  ];

  flake.modules.homeManager.web =
    {
      pkgs,
      ...
    }:
    {
      config = {
        home.packages = with pkgs; [
          pastel
          postman
        ];
      };
    };
}
