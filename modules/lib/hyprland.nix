{ lib, ... }:
let
  inherit (builtins)
    elemAt
    removeAttrs
    ;
  inherit (lib)
    concatStringsSep
    groupBy
    mapAttrs
    optional
    optionalAttrs
    ;

  toLua = lib.generators.toLua { };
  luaInline = lib.generators.mkLuaInline;

  isLua = configType: configType == "lua";

  mkLuaBind = spec: {
    _args = [
      (concatStringsSep " + " ((spec.modifiers or [ "SUPER" ]) ++ [ spec.key ]))
      (luaInline spec.lua)
    ]
    ++ optional ((spec.options or { }) != { }) spec.options;
  };

  mkLegacyBind =
    spec:
    concatStringsSep ", " (
      [
        "${concatStringsSep " " (spec.modifiers or [ "SUPER" ])}, ${spec.key}"
        spec.dispatcher
      ]
      ++ optional (spec ? argument && spec.argument != null && spec.argument != "") spec.argument
    );

  mkBinds =
    configType: specs:
    if isLua configType then
      { bind = map mkLuaBind specs; }
    else
      mapAttrs (_: map mkLegacyBind) (groupBy (spec: "bind${spec.legacyFlags or ""}") specs);

  mkConfig = configType: settings: if isLua configType then { config = settings; } else settings;

  mkAutostart =
    configType: commands:
    if isLua configType then
      {
        on = [
          {
            _args = [
              "hyprland.start"
              (luaInline (
                "function()\n"
                + concatStringsSep "" (map (command: "  hl.exec_cmd(${toLua command})\n") commands)
                + "end"
              ))
            ];
          }
        ];
      }
    else
      { "exec-once" = commands; };

  mkMonitors =
    configType: monitors:
    if isLua configType then { monitor = monitors; } else { monitorv2 = monitors; };

  mkPluginConfig =
    configType:
    {
      luaName,
      legacyName,
      settings,
    }:
    if isLua configType then
      mkConfig configType {
        plugin.${luaName} = settings;
      }
    else
      {
        plugin.${legacyName} = settings;
      };

  mkCurve = curve: {
    _args = [
      curve.name
      {
        type = "bezier";
        points = [
          [
            (elemAt curve.points 0)
            (elemAt curve.points 1)
          ]
          [
            (elemAt curve.points 2)
            (elemAt curve.points 3)
          ]
        ];
      }
    ];
  };

  renderLegacyCurve = curve: "${curve.name}, ${concatStringsSep ", " (map toString curve.points)}";

  renderLegacyAnimation =
    animation:
    concatStringsSep ", " (
      [
        animation.leaf
        (if animation.enabled then "1" else "0")
        (toString animation.speed)
        animation.bezier
      ]
      ++ optional (animation ? style) animation.style
    );

  mkAnimations =
    configType:
    {
      curves,
      animations,
    }:
    if isLua configType then
      {
        curve = map mkCurve curves;
        animation = animations;
      }
    else
      {
        animations = {
          bezier = map renderLegacyCurve curves;
          animation = map renderLegacyAnimation animations;
        };
      };

  mkLuaLayerRule =
    rule:
    removeAttrs rule [ "namespace" ]
    // {
      match.namespace = rule.namespace;
    };

  mkLegacyLayerRule =
    rule:
    {
      inherit (rule) name;
      "match:namespace" = rule.namespace;
    }
    // optionalAttrs (rule ? blur) {
      blur = if rule.blur then "on" else "off";
    }
    // optionalAttrs (rule ? blur_popups) {
      blur_popups = if rule.blur_popups then "on" else "off";
    }
    // optionalAttrs (rule ? dim_around) {
      dim_around = if rule.dim_around then "on" else "off";
    }
    // optionalAttrs (rule ? ignore_alpha) {
      inherit (rule) ignore_alpha;
    };

  mkLayerRules =
    configType: rules:
    if isLua configType then
      { layer_rule = map mkLuaLayerRule rules; }
    else
      { layerrule = map mkLegacyLayerRule rules; };
in
{
  flake.lib.custom.hyprlandLib = {
    inherit
      isLua
      mkAnimations
      mkAutostart
      mkBinds
      mkConfig
      mkLayerRules
      mkMonitors
      mkPluginConfig
      ;

    luaExec = command: "hl.dsp.exec_cmd(${toLua command})";
  };
}
