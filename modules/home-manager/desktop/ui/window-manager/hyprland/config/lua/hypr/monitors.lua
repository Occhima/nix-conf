local options = require("hypr.options")

local M = {}

function M.setup()
  local monitors = options.monitors[options.active_monitor_profile] or options.monitors.desktop

  for _, monitor in ipairs(monitors) do
    hl.monitor(monitor)
  end
end

return M
