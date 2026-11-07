{ config, lib, ... }:
let
  concatField = field: entries: lib.concatMap (entry: entry.${field} or [ ]) entries;
in
{
  den.quirks = {
    persist.description = "System paths kept across reboots on impermanent hosts";
  };

  den.aspects.impermanence = {
    persist.directories = [ "/var/lib" ];
    nixos =
      { persist, ... }:
      {
        imports = [ config.flake.modules.nixos.impermanence ];
        modules.system.file-system.impermanence = {
          files = concatField "files" persist;
          directories = concatField "directories" persist;
        };
      };
  };
}
