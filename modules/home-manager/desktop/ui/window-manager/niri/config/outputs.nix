{ osConfig, lib, ... }:
let

  inherit (builtins)
    elemAt
    length
    fromJSON
    isInt
    ;
  inherit (lib.strings) toInt;
  inherit (lib) nameValuePair mapAttrs' splitString;
  toFloat =
    s:
    let
      n = fromJSON s;
    in
    if isInt n then n + 0.0 else n;

  parseMonitorMeta =
    monitorMeta:
    let
      posParts = splitString "x" monitorMeta.position;
      modeParts = splitString "@" monitorMeta.mode;

      whStr = elemAt modeParts 0;
      whParts = splitString "x" whStr;

      width = toInt (elemAt whParts 0);
      height = toInt (elemAt whParts 1);
      refresh = if length modeParts > 1 then toFloat (elemAt modeParts 1) else null;

      x = toInt (elemAt posParts 0);
      y = toInt (elemAt posParts 1);
    in
    {
      scale = 1.0;
      position = { inherit x y; };
      mode = { inherit width height refresh; };
    };

  monitors = osConfig.modules.hardware.monitors or { };
  displays = monitors.displays or { };

  outputs = mapAttrs' (_name: v: nameValuePair v.output (parseMonitorMeta v)) displays;
in
{
  programs.niri.settings = {
    outputs = outputs;
  };
}
