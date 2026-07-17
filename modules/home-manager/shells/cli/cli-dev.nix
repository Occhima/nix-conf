{ occhima, ... }:
{
  config.occhima.cli-dev.includes = with occhima; [ distrobox ];
}
