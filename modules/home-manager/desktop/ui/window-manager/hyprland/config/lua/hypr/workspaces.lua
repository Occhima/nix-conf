-- hypr/workspaces.lua — mirrors hyprlang/workspaces.nix:
-- `per_monitor` persistent workspaces per monitor,
-- workspace id = monitor_index * per_monitor + slot.
-- Number binds target the *focused* monitor's block, same as the
-- hl-focus-workspace / hl-move-workspace scripts on the Nix side.

local options = require("hypr.options")
local util = require("hypr.util")

local M = {}

function M.setup()
  local per = options.workspaces.per_monitor
  local monitors = options.monitors[options.active_monitor_profile] or options.monitors.desktop
  local mod = options.main_mod

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
end

return M
