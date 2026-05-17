local M = {}

local once = {
  "wl-paste --type text --watch cliphist store",
  "wl-paste --type image --watch cliphist store",
  "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP",
}

function M.setup()
  hl.on("hyprland.start", function()
    for _, command in ipairs(once) do
      hl.exec_cmd(command)
    end
  end)
end

return M
