# Den: hosts, users, aspects and output generation — nothing more. The
# `occhima` namespace holds this repository's aspect library (exported as
# `flake.denful.occhima` for external reuse). Module bodies inside aspects
# stay plain NixOS/Home Manager modules, so Den remains replaceable.
{ inputs, ... }:
{
  flake-file.inputs.den.url = "github:denful/den";

  imports = [
    inputs.den.flakeModule
    (inputs.den.namespace "occhima" true)
  ];
}
