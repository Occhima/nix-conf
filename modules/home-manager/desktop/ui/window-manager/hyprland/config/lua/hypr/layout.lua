-- hypr/layout.lua — mirrors plugins/hy3.nix, dwindle when hy3 is not available.

local options = require("hypr.options")

local M = {}

function M.has_hy3()
  return options.plugins.hy3 ~= nil
end

function M.setup()
  if M.has_hy3() then
    hl.plugin.load(options.plugins.hy3)
    hl.config({ general = { layout = "hy3" } })
  else
    hl.config({
      general = { layout = "dwindle" },
      dwindle = { preserve_split = true },
    })
  end
end

return M
