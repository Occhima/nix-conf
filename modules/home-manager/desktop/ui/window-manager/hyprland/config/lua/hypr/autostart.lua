-- hypr/autostart.lua — mirrors the Home Manager systemd integration.

local M = {}

local once = {
  "dbus-update-activation-environment --systemd DISPLAY HYPRLAND_INSTANCE_SIGNATURE WAYLAND_DISPLAY XDG_CURRENT_DESKTOP XDG_SESSION_TYPE XDG_SESSION_ID"
    .. " && systemctl --user stop hyprland-session.target"
    .. " && systemctl --user start hyprland-session.target",
}

function M.setup()
  hl.on("hyprland.start", function()
    for _, command in ipairs(once) do
      hl.exec_cmd(command)
    end
  end)

  hl.on("hyprland.shutdown", function()
    os.execute("systemctl --user stop hyprland-session.target && sleep 0.1")
  end)
end

return M
