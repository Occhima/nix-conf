# Host: crescendoll — WSL.
{ den, nixos, ... }:
{
  den.aspects.crescendoll = {
    includes = [
      den.aspects.system-base
    ]
    ++ (map nixos [
      "wsl"
      "accounts"
      "network"
      "security-auth"
    ]);
  };
}
