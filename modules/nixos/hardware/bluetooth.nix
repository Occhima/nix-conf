{
  flake.modules.nixos.bluetooth =
    {
      lib,
      pkgs,
      ...
    }:
    let
      # BlueZ 5.86 logs a false startup failure when no controller defaults
      # need changing. This is fixed upstream and included in BlueZ 5.87.
      # https://github.com/bluez/bluez/commit/46937fd52f67f7a9dca9fd1cc367dabb4f029715
      bluez =
        if lib.versionOlder pkgs.bluez.version "5.87" then
          pkgs.bluez.overrideAttrs (previous: {
            postPatch = (previous.postPatch or "") + ''
              substituteInPlace src/adapter.c \
                --replace-fail \
                  $'\tif (mgmt_tlv_list_size(list) == 0)\n\t\tgoto done;' \
                  $'\t/* No changes from defaults */\n\tif (mgmt_tlv_list_size(list) == 0) {\n\t\tmgmt_tlv_list_free(list);\n\t\treturn;\n\t}'
            '';
          })
        else
          pkgs.bluez;
    in
    {
      hardware.bluetooth = {
        enable = true;
        package = bluez;
        powerOnBoot = true;
        settings = {
          General = {
            JustWorksRepairing = "always";
          };
        };
      };

      environment.systemPackages = [ pkgs.bluetui ];
    };
}
