{
  pkgs,
  config,
  lib,
  ...

}:
{

  config = {

    home.packages = [
      pkgs.hyprpicker
    ];

    wayland.windowManager.hyprland = {

      plugins = with pkgs.hyprlandPlugins; [
        # hyprexpo
        hyprsplit
        # (hyprsplit.overrideAttrs (_p: rec {
        #   # TODO: remove when in nixpkgs
        #   version = "0.51.0";
        #   src = pkgs.fetchFromGitHub {
        #     owner = "shezdy";
        #     repo = "hyprsplit";
        #     tag = "v${version}";
        #     hash = "sha256-h6vDtBKTfyuA/6frSFcTrdjoAKhwlGBT+nzjoWf9sQE=";
        #   };
        # })
        # )

        hyprfocus
      ];

      settings = {
        plugins = {
          # FIXME: Don't know why but hyprexpo just stopped working
          # hyprexpo = {
          #   rows = 4;
          #   columns = 4;
          #   gap_size = config.wayland.windowManager.hyprland.settings.general.gaps_in;
          # };
          hyprsplit = {
            num_workspaces = 9;
            # persistent_workspaces = true;
          };
        };
        bind = [
          # plugins
          "$mainMod, C, exec, ${lib.getExe pkgs.hyprpicker}"

          # hyrpexpo
          # "$mainMod, TAB, hyprexpo:expo, toggle"

          # hyprsplit
          "$mainMod, 1, split:workspace, 1"
          "$mainMod, 2, split:workspace, 2"
          "$mainMod, 3, split:workspace, 3"
          "$mainMod, 4, split:workspace, 4"
          "$mainMod, 5, split:workspace, 5"
          "$mainMod, 6, split:workspace, 6"
          "$mainMod, 7, split:workspace, 7"
          "$mainMod, 8, split:workspace, 8"
          "$mainMod, 9, split:workspace, 9"

          "$mainMod SHIFT, 1, split:movetoworkspacesilent, 1"
          "$mainMod SHIFT, 2, split:movetoworkspacesilent, 2"
          "$mainMod SHIFT, 3, split:movetoworkspacesilent, 3"
          "$mainMod SHIFT, 4, split:movetoworkspacesilent, 4"
          "$mainMod SHIFT, 5, split:movetoworkspacesilent, 5"
          "$mainMod SHIFT, 6, split:movetoworkspacesilent, 6"
          "$mainMod SHIFT, 7, split:movetoworkspacesilent, 7"
          "$mainMod SHIFT, 8, split:movetoworkspacesilent, 8"
          "$mainMod SHIFT, 9, split:movetoworkspacesilent, 9"

          "$mainMod, D, split:swapactiveworkspaces, current +1"
          "$mainMod, G, split:grabroguewindows"

        ];
        animations = {
          bezier = [
            "focusIn, 1, -0.07, -0.1, 0.95"
            "focusOut, 1, -0.07, -0.1, 0.95"
          ];
          animation = [
            "hyprfocusIn, 1, 0.25, focusIn"
            "hyprfocusOut, 1, 0.25, focusOut"
          ];

        };
      };
    };
  };

}
