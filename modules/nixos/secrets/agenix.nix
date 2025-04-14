# XXX: I believe that this is not the correct way to use the rekey mod,
# the docs say that I  don't need a secrets.nix file, but it's exactly what im doing here ....
{
  config,
  lib,
  inputs,
  ...
}:

with builtins;
with lib;
with lib.types;
with lib.filesystem;
let

  cfg = config.modules.secrets.agenix-rekey;

  mapSecrets =
    secretsDir:
    let
      secretsStr = toString secretsDir;
      removeSecretsDirPrefix = file: replaceStrings [ (secretsStr + "/") ] [ "" ] (toString file);
      allFiles = listFilesRecursive secretsDir;
      ageFiles = filter (file: hasSuffix ".age" file) allFiles;
      attrsList = map (file: {
        name = removeSuffix ".age" (removeSecretsDirPrefix file);
        value = {
          rekeyFile = file;
        };
      }) ageFiles;
    in
    listToAttrs attrsList;

in

# TODO:
# mapSecrets =
{
  imports = [
    inputs.agenix.nixosModules.default
    inputs.agenix-rekey.nixosModules.default
  ];

  options.modules.secrets.agenix-rekey = {
    enable = mkEnableOption "Agenix rekey secret management";

    hostPublicKey = mkOption {
      type = path;
      default = /.;
      example = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAI.." ];
      description = "SSH pub keys path for decryption";
    };
    publicKeys = mkOption {
      type = listOf path;
      default = [ /. ];
      example = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAI.." ];
      description = "SSH pub keys for decryption";
    };
    secretsDir = mkOption {
      type = path;
      default = /.;
      example = [ "./secrets" ];
      description = "A directory containing .age secrets";
    };
    storageDir = mkOption {
      type = path;
      example = [ "./secrets" ];
      description = "A directory where all the keys will be rekeyed for the host";
    };
  };

  config = mkIf cfg.enable {
    age = {
      secrets = mapSecrets cfg.secretsDir;
      rekey = {
        storageMode = mkDefault "local";
        hostPubkey = cfg.hostPublicKey;
        masterIdentities = cfg.publicKeys;
        localStorageDir = cfg.storageDir; # by default, It's inside the module call, already with the host defined
      };
      identityPaths = cfg.publicKeys;
    };

  };
}
