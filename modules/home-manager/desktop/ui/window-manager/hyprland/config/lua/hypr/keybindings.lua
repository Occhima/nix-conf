-- hypr/keybindings.lua — mirrors core/keybindings.nix, plugins/*.nix,
-- the guernica quickshell binds and gamemode.nix.
-- Workspace number binds live in hypr/workspaces.lua.

local options = require("hypr.options")
local util = require("hypr.util")
local layout = require("hypr.layout")

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
    { mod .. " + D", hl.dsp.focus({ monitor = "+1" }) },
    { mod .. " + C", util.exec(programs.color_picker) },
    { mod .. " + F", hl.dsp.window.fullscreen({ action = "toggle" }) },
    { mod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true } },
    { mod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true } },
  })
end

-- plugins/hy3.nix; dwindle equivalents when hy3 is not loaded.
local function bind_layout()
  local directions = { "left", "right", "up", "down" }

  if layout.has_hy3() then
    local hy3 = hl.plugin.hy3
    util.bind_all({
      { mod .. " + T", hy3.make_group("tab") },
      { mod .. " + H", hy3.make_group("h") },
      { mod .. " + U", hy3.make_group("v") },
      { mod .. " + A", hy3.change_focus("raise") },
      { mod .. " + SHIFT + A", hy3.change_focus("lower") },
    })
    for _, direction in ipairs(directions) do
      hl.bind(mod .. " + " .. direction, hy3.move_focus(direction))
      hl.bind(mod .. " + CTRL + " .. direction, hy3.move_window(direction))
    end
  else
    hl.bind(mod .. " + J", hl.dsp.layout("togglesplit"))
    for _, direction in ipairs(directions) do
      hl.bind(mod .. " + " .. direction, hl.dsp.focus({ direction = direction }))
    end
  end
end

-- guernica-ukishima quickshell island panels.
local function bind_guernica_shell()
  util.when_enabled(features.guernica_shell, function()
    local panels = {
      { "SPACE", "launcher" },
      { "X", "clipboard" },
      { "CTRL + B", "bluetooth" },
      { "CTRL + M", "mixer" },
      { "CTRL + S", "system" },
      { "CTRL + A", "calendar" },
      { "CTRL + U", "media" },
      { "CTRL + N", "notifications" },
      { "CTRL + I", "network" },
      { "CTRL + P", "power" },
      { "CTRL + ESCAPE", "hide" },
    }
    for _, panel in ipairs(panels) do
      hl.bind(mod .. " + " .. panel[1], util.exec(programs.quickshell .. " " .. panel[2]))
    end
  end)
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
  bind_layout()
  bind_guernica_shell()
  bind_optional_apps()
  bind_gamemode()
end

return M
