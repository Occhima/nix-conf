local M = {}

function M.setup()
  hl.config({
    ecosystem = {
      no_update_news = true,
      no_donation_nag = true,
    },
    misc = {
      enable_swallow = true,
      mouse_move_enables_dpms = true,
      key_press_enables_dpms = true,
      disable_autoreload = true,
    },
  })
end

return M
