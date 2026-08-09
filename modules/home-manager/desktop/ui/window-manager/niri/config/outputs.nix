{
  flake.modules.homeManager.niri =
    {
      osConfig ? { },
      lib,
      ...
    }:
    let
      inherit (lib) nameValuePair mapAttrs';

      monitors = osConfig.modules.hardware.monitors or { };
      primary = monitors.primaryMonitorName or "";
      displays = monitors.displays or { };

      renderTransform = transform: {
        rotation = (transform - (if transform >= 4 then 4 else 0)) * 90;
        flipped = transform >= 4;
      };

      # Typed fields flow straight through — no string parsing.
      outputs = mapAttrs' (
        name: d:
        nameValuePair d.output {
          inherit (d) enable scale;
          focus-at-startup = name == primary;
          position = {
            inherit (d) x y;
          };
          mode = {
            inherit (d) width height;
            refresh = if d.refreshRate == null then null else d.refreshRate * 1.0;
          };
          transform = renderTransform d.transform;
        }
      ) displays;
    in
    {
      programs.niri.settings.outputs = outputs;
    };
}
