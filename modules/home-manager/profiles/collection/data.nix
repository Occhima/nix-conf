{
  flake.modules.homeManager.data =
    # NOTE: Stolen from: https://github.com/s3igo/dotfiles/blob/82929b20af8f66acfbbc41a614fbfbb9de1385e6/home/aider.nix#L4
    {
      config,
      pkgs,
      ...
    }:
    {
      config = {
        home = {
          packages = [
            pkgs.xleak
          ];
        };
      };
    };
}
