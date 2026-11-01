-- hypr/theme.lua — look & feel, mirrors the guernica theme targets
-- (border/group colours, shadow, layer rules for the shells).

local M = {}

local colors = {
  active = "rgb(40c4ff)",
  inactive = "rgb(909090)",
  locked = "rgb(c080ff)",
  text = "rgb(f8f8f8)",
  background = "rgb(141818)",
  shadow = "rgba(14181899)",
}

local layer_rules = {
  { name = "anyrun", match = { namespace = "anyrun" }, blur = false, blur_popups = true, dim_around = true },
  { name = "waybar", match = { namespace = "waybar" }, blur = false },
  { name = "quickshell", match = { namespace = "quickshell" }, blur = true, blur_popups = true, dim_around = true },
  {
    name = "guernica-ukishima",
    match = { namespace = "guernica-ukishima" },
    blur = true,
    blur_popups = true,
    ignore_alpha = 0.06,
  },
}

local function configure_theme()
  hl.config({
    general = {
      gaps_in = 8,
      gaps_out = 20,
      border_size = 1,
      ["col.active_border"] = colors.active,
      ["col.inactive_border"] = colors.inactive,
    },
    group = {
      ["col.border_active"] = colors.active,
      ["col.border_inactive"] = colors.inactive,
      ["col.border_locked_active"] = colors.locked,
      groupbar = {
        ["col.active"] = colors.active,
        ["col.inactive"] = colors.inactive,
        text_color = colors.text,
      },
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
        color = colors.shadow,
      },
    },
    misc = {
      background_color = colors.background,
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
