{
  flake.modules.homeManager.niri =
    {
      osConfig ? { },
      lib,
      ...
    }:
    let
      inherit (lib) nameValuePair mapAttrs' filterAttrs;

      monitors = osConfig.modules.hardware.monitors or { };
      displays = monitors.displays or { };
      enabled = filterAttrs (_: d: d.enable) displays;

      # Typed fields flow straight through — no string parsing.
      outputs = mapAttrs' (
        _name: d:
        nameValuePair d.output {
          scale = d.scale;
          position = {
            inherit (d) x y;
          };
          mode = {
            inherit (d) width height;
            refresh = d.refreshRate;
          };
        }
      ) enabled;
    in
    {
      programs.niri.settings = {
        outputs = outputs;
      };
    };
}
