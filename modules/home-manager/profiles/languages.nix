# Aggregate: development language toolchains in daily use.
{ occhima, ... }:
{
  config.occhima.languages.includes = with occhima; [
      python
      c
      julia
    ];
}
