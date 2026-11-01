-- hypr/workspaces.lua — mirrors plugins/split-monitor-workspaces.nix:
-- `per_monitor` workspaces per monitor through the split-monitor-workspaces
-- Lua module. Without it, falls back to the old id math:
-- workspace id = monitor_index * per_monitor + slot on the focused monitor.

local options = require("hypr.options")
local util = require("hypr.util")

local M = {}

local function setup_split_monitor_workspaces(per, mod)
  package.path = package.path .. ";" .. options.plugins.split_monitor_workspaces .. "/lua/?.lua"
  local smw = require("split-monitor-workspaces")
  smw.setup({ workspace_count = per })

  for slot = 1, per do
    hl.bind(mod .. " + " .. slot, function()
      smw.workspace(tostring(slot))()
    end)
    hl.bind(mod .. " + SHIFT + " .. slot, function()
      smw.move_to_workspace_silent(tostring(slot))()
    end)
  end

  util.bind_all({
    {
      mod .. " + bracketright",
      function()
        smw.cycle_workspaces("next")()
      end,
    },
    {
      mod .. " + bracketleft",
      function()
        smw.cycle_workspaces("prev")()
      end,
    },
    {
      mod .. " + mouse_down",
      function()
        smw.cycle_workspaces("next")()
      end,
    },
    {
      mod .. " + mouse_up",
      function()
        smw.cycle_workspaces("prev")()
      end,
    },
    {
      mod .. " + SHIFT + G",
      function()
        smw.grab_rogue_windows()()
      end,
    },
  })
end

local function setup_fallback(per, mod, monitors)
  for index, monitor in ipairs(monitors) do
    for slot = 1, per do
      hl.workspace_rule({
        workspace = tostring((index - 1) * per + slot),
        monitor = monitor.output,
        persistent = true,
        default = (index == 1 and slot == 1) or nil,
      })
    end
  end

  for slot = 1, per do
    hl.bind(mod .. " + " .. slot, function()
      hl.exec_cmd("hyprctl dispatch workspace " .. (util.focused_monitor_index() * per + slot))
    end)
    hl.bind(mod .. " + SHIFT + " .. slot, function()
      hl.exec_cmd("hyprctl dispatch movetoworkspacesilent " .. (util.focused_monitor_index() * per + slot))
    end)
  end

  util.bind_all({
    { mod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }) },
    { mod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }) },
  })
end

function M.setup()
  local per = options.workspaces.per_monitor
  local monitors = options.monitors[options.active_monitor_profile] or options.monitors.desktop
  local mod = options.main_mod

  if options.plugins.split_monitor_workspaces then
    setup_split_monitor_workspaces(per, mod)
  else
    setup_fallback(per, mod, monitors)
  end
end

return M
