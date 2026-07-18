{
  flake.modules.homeManager.browser-brave =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.brave ];
    };
}
