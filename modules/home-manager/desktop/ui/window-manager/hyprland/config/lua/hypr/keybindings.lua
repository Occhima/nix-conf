-- hypr/keybindings.lua — mirrors hyprlang/keybindings.nix (+ gamemode.nix).
-- Workspace number binds live in hypr/workspaces.lua.

local options = require("hypr.options")
local util = require("hypr.util")

local M = {}

local mod = options.main_mod
local programs = options.programs
local features = options.features

local function bind_core()
  util.bind_all({
    { mod .. " + Q", util.exec(programs.terminal) },
    { mod .. " + K", hl.dsp.window.close() },
    { mod .. " + SHIFT + M", hl.dsp.exit() },
    { mod .. " + SHIFT + R", util.exec("hyprctl reload") },
    { mod .. " + V", hl.dsp.window.float({ action = "toggle" }) },
    { mod .. " + J", hl.dsp.layout("togglesplit") },
    { mod .. " + left", hl.dsp.focus({ direction = "left" }) },
    { mod .. " + right", hl.dsp.focus({ direction = "right" }) },
    { mod .. " + up", hl.dsp.focus({ direction = "up" }) },
    { mod .. " + down", hl.dsp.focus({ direction = "down" }) },
    { mod .. " + C", util.exec(programs.color_picker) },
    { mod .. " + F", hl.dsp.window.fullscreen({ mode = "fullscreen", action = "toggle" }) },
    { mod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }) },
    { mod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }) },
    { mod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true } },
    { mod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true } },
  })
end

local function bind_optional_apps()
  util.when_enabled(features.flameshot, function()
    hl.bind(mod .. " + S", util.exec(programs.screenshot))
  end)

  util.when_enabled(features.wlogout, function()
    hl.bind(mod .. " + W", util.exec(programs.logout))
  end)

  util.when_enabled(features.hyprlock, function()
    hl.bind(mod .. " + L", util.exec(programs.lock))
  end)

  util.when_enabled(features.emacs_service, function()
    hl.bind(mod .. " + E", util.exec(programs.emacs))
  end)
end

-- hyprlang/gamemode.nix: toggle animations/blur/shadow/gaps, reload to revert.
local function bind_gamemode()
  util.when_enabled(features.steam, function()
    hl.bind(mod .. " + G", function()
      local animations = hl.get_config("animations.enabled")
      local enabled = animations == true or animations == 1

      if enabled then
        hl.config({
          animations = { enabled = false },
          decoration = {
            rounding = 0,
            fullscreen_opacity = 1,
            shadow = { enabled = false },
            blur = { enabled = false },
          },
          general = {
            gaps_in = 0,
            gaps_out = 0,
            border_size = 1,
          },
        })
        hl.animation({ leaf = "borderangle", enabled = false })
        hl.notification.create({ text = "Gamemode [ON]", timeout = 5000, color = "rgb(40a02b)", icon = "ok" })
      else
        hl.notification.create({ text = "Gamemode [OFF]", timeout = 5000, color = "rgb(d20f39)", icon = "ok" })
        hl.exec_cmd("hyprctl reload")
      end
    end)
  end)
end

function M.setup()
  bind_core()
  bind_optional_apps()
  bind_gamemode()
end

return M
