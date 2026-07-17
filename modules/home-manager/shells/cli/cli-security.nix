{ occhima, ... }:
{
  config.occhima.cli-security.includes = with occhima; [
      ssh
      gpg
    ];
}
