{ inputs, ... }:
{

  imports = [
    inputs.agenix-rekey.flakeModule
  ];

  perSystem =
    { ... }:
    {
      agenix-rekey = {
        collectHomeManagerConfigurations = true;
      };
    };

}
