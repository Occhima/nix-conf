# agenix-rekey flake integration. Hosts that participate in rekeying
# register themselves via `perSystem.agenix-rekey.nixosConfigurations.<host>`
# from their own host module — there is no central host list here.
{ inputs, ... }:
{
  imports = [ inputs.agenix-rekey.flakeModule ];

  perSystem = _: {
    agenix-rekey = {
      collectHomeManagerConfigurations = false;
    };
  };
}
