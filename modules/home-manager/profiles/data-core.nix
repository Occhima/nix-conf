# Aggregate: personal data management — XDG layout, persistence,
# Dropbox (maestral) and mail accounts.
{ config, ... }:
{
  flake.modules.homeManager.data-core.imports = with config.flake.modules.homeManager; [
      xdg
      persistence
      maestral
      email
    ];
}
