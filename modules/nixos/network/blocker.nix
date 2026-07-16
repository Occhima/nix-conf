{ ... }:
{
  config.flake.modules.nixos.blocker =
    {
      config,
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
