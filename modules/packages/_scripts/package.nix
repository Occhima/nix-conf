{
  writeShellApplication,
  symlinkJoin,
  coreutils,
  gnugrep,
  nix,
}:
let
  inherit (builtins) readFile;

  run-vm = writeShellApplication {
    name = "run-vm";
    runtimeInputs = [
      coreutils
      gnugrep
      nix
    ];
    text = readFile ./run-vm.sh;
  };
in
{
  inherit run-vm;

  scripts = symlinkJoin {
    name = "nixos-scripts";
    paths = [
      run-vm
    ];
  };
}
