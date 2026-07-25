-- hypr/util.lua — shared helpers for binds and monitor math.

local M = {}

function M.exec(command)
  return hl.dsp.exec_cmd(command)
end

-- bindings: list of { keys, dispatcher, flags? }
function M.bind_all(bindings)
  for _, binding in ipairs(bindings) do
    hl.bind(binding[1], binding[2], binding[3])
  end
end

function M.when_enabled(enabled, callback)
  if enabled then
    callback()
  end
end

-- 0-based index of the focused monitor, in `hyprctl monitors` order.
-- Same heuristic as hl-focus-workspace in hyprlang/workspaces.nix.
function M.focused_monitor_index()
  local pipe = io.popen("hyprctl monitors -j")
  if not pipe then
    return 0
  end
  local out = pipe:read("*a") or "[]"
  pipe:close()

  local index = 0
  for entry in out:gmatch("{[^{}]*}") do
    if entry:find('"focused"%s*:%s*true') then
      return index
    end
    index = index + 1
  end
  return 0
end

return M
