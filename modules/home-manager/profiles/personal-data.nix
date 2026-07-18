# Aggregate: personal data management — XDG layout, persistence,
# Dropbox (maestral) and mail accounts.
{ config, ... }:
let
  hm = config.flake.modules.homeManager;
in
{
  flake.modules.homeManager.personal-data.imports = [
    hm.xdg
    hm.persistence
    hm.maestral
    hm.email
  ];
}
