{ occhima, ... }:
{
  occhima.cli-security.includes = with occhima; [
      ssh
      gpg
    ];
}
