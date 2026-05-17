local options = require("hypr.options")

local M = {}

function M.setup()
  hl.config({
    input = {
      kb_layout = options.input.kb_layout,
      kb_variant = options.input.kb_variant,
      kb_options = options.input.kb_options,
      follow_mouse = 1,
      sensitivity = -0.5,
      repeat_delay = 250,
      repeat_rate = 50,
      touchpad = {
        natural_scroll = false,
      },
      tablet = {
        transform = 1,
        output = options.input.primary_tablet_output,
      },
    },
    cursor = {
      no_hardware_cursors = true,
    },
  })
end

return M
