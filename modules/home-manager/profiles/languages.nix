# Aggregate: development language toolchains in daily use.
{ occhima, ... }:
{
  occhima.languages.includes = with occhima; [
      python
      c
      julia
    ];
}
