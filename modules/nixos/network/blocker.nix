{
  flake.modules.nixos.blocker =
    {
      ...
    }:
    {
      options.modules.network.blocker = {
      };

      config = {
        networking.stevenblack = {
          enable = true;
          block = [
            "fakenews"
            "gambling"
            "porn"
          ];
        };
      };
    };
}
