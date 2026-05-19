local options = require("hypr.options")
local util = require("hypr.util")

local M = {}

local mod = options.main_mod
local programs = options.programs
local features = options.features

local function bind_core()
  util.bind_all({
    { mod .. " + Q", util.exec(programs.terminal) },
    { mod .. " + F4", hl.dsp.window.close() },
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

local function bind_launchers()
  util.when_enabled(features.rofi, function()
    util.bind_all({
      { mod .. " + SPACE", util.exec("rofi -show drun") },
      { mod .. " + B", util.exec("rofi-bluetooth") },
      { mod .. " + P", util.exec("rofi -show power-menu -modi power-menu:rofi-power-menu") },
    })
  end)

  util.when_enabled(features.anyrun, function()
    hl.bind(mod .. " + SPACE", util.exec(programs.launcher))
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

  util.when_enabled(features.clipboard and features.rofi, function()
    hl.bind(mod .. " + K", util.exec(programs.clipboard_menu))
  end)
end

local function bind_hyprsplit()
  util.when_enabled(features.hyprsplit, function()
    for workspace = 1, 9 do
      hl.bind(mod .. " + " .. workspace, util.exec("hyprctl dispatch split:workspace " .. workspace))
      hl.bind(
        mod .. " + SHIFT + " .. workspace,
        util.exec("hyprctl dispatch split:movetoworkspacesilent " .. workspace)
      )
    end

    hl.bind(mod .. " + D", util.exec("hyprctl dispatch split:swapactiveworkspaces current +1"))
    hl.bind(mod .. " + G", util.exec("hyprctl dispatch split:grabroguewindows"))
  end)
end

local function focused_mon_index()
  local pipe = io.popen("hyprctl monitors -j")
  if not pipe then
    return 0
  end
  local out = pipe:read("*a") or "[]"
  pipe:close()
  local i = 0
  for entry in out:gmatch("{[^{}]*}") do
    if entry:find('"focused"%s*:%s*true') then
      return i
    end
    i = i + 1
  end
  return 0
end

local function bind_native_workspaces()
  util.when_enabled(features.native_workspaces, function()
    local per = (options.workspaces or { per_monitor = 9 }).per_monitor

    for slot = 1, per do
      hl.bind(mod .. " + " .. slot, function()
        local target = focused_mon_index() * per + slot
        hl.exec_cmd("hyprctl dispatch workspace " .. target)
      end)
      hl.bind(mod .. " + SHIFT + " .. slot, function()
        local target = focused_mon_index() * per + slot
        hl.exec_cmd("hyprctl dispatch movetoworkspacesilent " .. target)
      end)
    end
  end)
end

local function bind_split_monitor_workspaces()
  util.when_enabled(features.split_monitor_workspaces, function()
    local per = (options.workspaces or { per_monitor = 9 }).per_monitor

    for slot = 1, per do
      hl.bind(mod .. " + " .. slot, util.exec("hyprctl dispatch split-workspace " .. slot))
      hl.bind(mod .. " + SHIFT + " .. slot, util.exec("hyprctl dispatch split-movetoworkspacesilent " .. slot))
    end

    hl.bind(mod .. " + G", util.exec("hyprctl dispatch split-grabroguewindows"))
  end)
end

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
        hl.notification.create({ text = "Gamemode [ON]", duration = 5000, color = "rgb(40a02b)", icon = "ok" })
      else
        hl.notification.create({ text = "Gamemode [OFF]", duration = 5000, color = "rgb(d20f39)", icon = "ok" })
        hl.exec_cmd("hyprctl reload")
      end
    end)
  end)
end

function M.setup()
  bind_core()
  bind_launchers()
  bind_optional_apps()
  bind_hyprsplit()
  bind_native_workspaces()
  bind_split_monitor_workspaces()
  bind_gamemode()
end

return M
