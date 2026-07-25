# Den aspect for occhima: composes the plain NixOS and Home Manager user
# modules. No account or home configuration is duplicated here.
{ config, ... }: {
  den.aspects.occhima = {
    nixos.imports = [ config.flake.modules.nixos.user-occhima ];
    homeManager.imports = [ config.flake.modules.homeManager.user-occhima ];
  };
}
