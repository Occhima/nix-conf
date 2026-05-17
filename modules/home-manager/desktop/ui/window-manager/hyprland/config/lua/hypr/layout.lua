local M = {}

function M.setup()
  hl.config({
    dwindle = {
      pseudotile = true,
      preserve_split = true,
    },
  })
end

return M
