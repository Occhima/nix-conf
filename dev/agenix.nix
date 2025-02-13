{ inputs, ... }:
{

  imports = [
    inputs.agenix-rekey.flakeModule
    # inputs.agenix-shell.flakeModule
  ];

  perSystem =
    { ... }:
    {
      agenix-rekey = {
        collectHomeManagerConfigurations = true;
      };
    };

}
