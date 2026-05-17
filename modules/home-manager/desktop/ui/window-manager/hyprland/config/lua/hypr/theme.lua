local options = require("hypr.options")

local M = {}

local function configure_layer_rules()
  local rules = {
    { name = "anyrun-no-blur", match = { namespace = "anyrun" }, blur = false },
    { name = "anyrun-popup-blur", match = { namespace = "anyrun" }, blur_popups = true },
    { name = "anyrun-dim", match = { namespace = "anyrun" }, dim_around = true },
    { name = "waybar-no-blur", match = { namespace = "waybar" }, blur = false },
    { name = "quickshell-blur", match = { namespace = "quickshell" }, blur = true },
    { name = "quickshell-popup-blur", match = { namespace = "quickshell" }, blur_popups = true },
    { name = "quickshell-dim", match = { namespace = "quickshell" }, dim_around = true },
  }

  for _, rule in ipairs(rules) do
    hl.layer_rule(rule)
  end
end

local function configure_base_theme()
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
      enabled = true,
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

local function configure_compact_theme()
  hl.config({
    general = {
      gaps_in = 4,
      gaps_out = 6,
      border_size = 2,
      resize_on_border = false,
      layout = "master",
    },
    dwindle = {
      pseudotile = true,
      preserve_split = true,
      special_scale_factor = 0.8,
    },
    master = {
      new_status = "master",
      new_on_top = true,
      mfact = 0.5,
    },
    decoration = {
      rounding = 10,
      active_opacity = 1.0,
      fullscreen_opacity = 1.0,
      dim_inactive = false,
      dim_strength = 0.1,
      dim_special = 0.8,
      shadow = {
        enabled = false,
        range = 6,
        render_power = 1,
        color = "rgb(8bd5ca)",
        color_inactive = "rgb(c6a0f6)",
      },
      blur = {
        enabled = true,
        size = 12,
        passes = 3,
        noise = 0.0200,
        vibrancy = 0.1796,
        ignore_opacity = true,
        new_optimizations = true,
        special = true,
        popups = true,
      },
    },
    animations = {
      enabled = true,
    },
  })

  hl.curve("wind", { type = "bezier", points = { { 0.05, 0.69 }, { 0.1, 1 } } })
  hl.curve("winIn", { type = "bezier", points = { { 0.1, 1.1 }, { 0.1, 1 } } })
  hl.curve("winOut", { type = "bezier", points = { { 0.3, 1 }, { 0, 1 } } })
  hl.curve("linear", { type = "bezier", points = { { 1, 1 }, { 1, 1 } } })
  hl.curve("easeOut", { type = "bezier", points = { { 0.16, 1 }, { 0.3, 1 } } })
  hl.animation({ leaf = "windows", enabled = true, speed = 6.9, bezier = "easeOut", style = "slide" })
  hl.animation({ leaf = "windowsIn", enabled = true, speed = 6.9, bezier = "easeOut", style = "popin 90%" })
  hl.animation({ leaf = "windowsOut", enabled = true, speed = 6.9, bezier = "easeOut", style = "popin 80%" })
  hl.animation({ leaf = "windowsMove", enabled = true, speed = 6.9, bezier = "easeOut", style = "slide" })
  hl.animation({ leaf = "fade", enabled = true, speed = 10, bezier = "default" })
  hl.animation({ leaf = "workspaces", enabled = true, speed = 10, bezier = "easeOut", style = "slide" })
  hl.animation({ leaf = "layers", enabled = true, speed = 6.9, bezier = "easeOut", style = "slide" })
end

function M.setup()
  configure_base_theme()
  configure_layer_rules()

  if options.features.compact_theme then
    configure_compact_theme()
  end
end

return M
