-- hypr/autostart.lua — mirrors hyprlang/exec.nix (exec-once).

local M = {}

local once = {
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
