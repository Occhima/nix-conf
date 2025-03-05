{
  writeShellApplication,
  symlinkJoin,
  coreutils,
}:
let
  inherit (builtins) readFile;

  run-vm = writeShellApplication {
    name = "run-vm";
    runtimeInputs = [
      coreutils
    ];
    text = readFile ./scripts/run-vm.sh;
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
