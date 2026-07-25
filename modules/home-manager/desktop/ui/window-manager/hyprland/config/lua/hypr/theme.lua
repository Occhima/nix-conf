-- hypr/theme.lua — look & feel for the backup config.
-- hyprlang/ keeps most of this at Hyprland defaults (general.nix is all
-- comments, animations.nix only enables them); the values below are the
-- backup's own theme, plus layer rules for the launcher/bar shells.

local M = {}

local layer_rules = {
  { name = "anyrun-no-blur", match = { namespace = "anyrun" }, blur = false },
  { name = "anyrun-popup-blur", match = { namespace = "anyrun" }, blur_popups = true },
  { name = "anyrun-dim", match = { namespace = "anyrun" }, dim_around = true },
  { name = "waybar-no-blur", match = { namespace = "waybar" }, blur = false },
  { name = "quickshell-blur", match = { namespace = "quickshell" }, blur = true },
  { name = "quickshell-popup-blur", match = { namespace = "quickshell" }, blur_popups = true },
  { name = "quickshell-dim", match = { namespace = "quickshell" }, dim_around = true },
}

local function configure_theme()
  hl.config({
    general = {
      layout = "dwindle",
      gaps_in = 8,
      gaps_out = 20,
      border_size = 1,
    },
    decoration = {
      rounding = 5,
      active_opacity = 0.9,
      inactive_opacity = 0.7,
      blur = {
        enabled = true,
        size = 12,
        passes = 3,
        xray = true,
        noise = 0.10,
        ignore_opacity = true,
      },
      shadow = {
        enabled = true,
        range = 12,
        render_power = 3,
      },
    },
    animations = {
      enabled = true, -- hyprlang/animations.nix
    },
  })

  hl.curve("myBezier", { type = "bezier", points = { { 0.05, 0.9 }, { 0.1, 1.0 } } })
  hl.curve("myBezier2", { type = "bezier", points = { { 0.0, 0.1 }, { 0.0, 1.0 } } })

  hl.animation({ leaf = "windows", enabled = true, speed = 3, bezier = "myBezier" })
  hl.animation({ leaf = "windowsOut", enabled = true, speed = 3, bezier = "default", style = "popin 80%" })
  hl.animation({ leaf = "border", enabled = true, speed = 20, bezier = "default" })
  hl.animation({ leaf = "borderangle", enabled = true, speed = 8, bezier = "default" })
  hl.animation({ leaf = "fade", enabled = true, speed = 7, bezier = "default" })
  hl.animation({ leaf = "workspaces", enabled = false, speed = 2, bezier = "myBezier2" })
end

function M.setup()
  configure_theme()

  for _, rule in ipairs(layer_rules) do
    hl.layer_rule(rule)
  end
end

return M
