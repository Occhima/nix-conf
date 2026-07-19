-- hypr/layout.lua — mirrors hyprlang/layout.nix (dwindle only).

local M = {}

function M.setup()
  hl.config({
    dwindle = {
      preserve_split = true,
    },
  })
end

return M
