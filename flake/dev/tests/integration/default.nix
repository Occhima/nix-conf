{ self, lib, ... }:
let
  hosts = [
    "aerodynamic"
    "steammachine"
  ];

  # TODO: this is not working ( yet...)
  mkTest =
    host: pkgs:
    pkgs.testers.runNixosTest {
      name = "Test if ${host} is booting";
      nodes = {
        pkgsReadOnly = false;
        machine =
          { ... }:
          {
            imports = [ self.nixosModules ];

          };
      };
      testScript = ''
        machine.start()
        machine.wait_for_unit("multi-user.target")
        machine.succeed("uname -a")
      '';
    };
in
{
  perSystem =
    { pkgs, ... }:
    {
      checks = lib.genAttrs hosts (host: mkTest host pkgs);
    };
}
