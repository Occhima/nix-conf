{
  inputs,
  ...
}:
let
  loadDiskoConfig = path: {
    aerodynamic = import (path + "/aerodynamic.nix");
    steammachine = import (path + "/steammachine.nix");
    face2face = import (path + "/face2face.nix");
    beyond = import (path + "/beyond.nix");
  };

in
{

  imports = [ inputs.disko.flakeModule ];

  flake.diskoConfigurations = loadDiskoConfig ../../modules/nixos/system/file-system/partitions;

}
