{ config, ... }:
let
  inherit (config.flake.lib.custom) hyprlandLib;
in
{
  flake.modules.homeManager.hyprland =
    {
      config,
      osConfig ? { },
      pkgs,
      lib,
      ...
    }:
    let
      inherit (lib) mkIf;

      gamemode = pkgs.writeShellApplication {
        name = "gamemode";
        runtimeInputs = with pkgs; [
          gawk
          hyprland
        ];
        text = ''
          hypr_gamemode="$(hyprctl getoption animations:enabled | awk 'NR == 1 { print $2 }')"
          if [ "$hypr_gamemode" = 1 ]; then
            hyprctl --batch "keyword animations:enabled 0; keyword animation borderangle,0; keyword decoration:shadow:enabled 0; keyword decoration:blur:enabled 0; keyword decoration:fullscreen_opacity 1; keyword general:gaps_in 0; keyword general:gaps_out 0; keyword general:border_size 1; keyword decoration:rounding 0"
            hyprctl notify 1 5000 "rgb(40a02b)" "Gamemode [ON]"
          else
            hyprctl notify 1 5000 "rgb(d20f39)" "Gamemode [OFF]"
            hyprctl reload
          fi
        '';
      };
    in
    {
      config = mkIf (osConfig.modules.services.steam.enable or false) {
        wayland.windowManager.hyprland.settings =
          hyprlandLib.mkBinds config.wayland.windowManager.hyprland.configType
            [
              {
                key = "G";
                dispatcher = "exec";
                argument = "${gamemode}/bin/gamemode";
                lua = hyprlandLib.luaExec "${gamemode}/bin/gamemode";
              }
            ];
      };
    };
}
