-- hypr/options.lua — single source of truth for the backup config.
-- Values mirror hyprlang/*.nix; monitor/workspace data mirrors what
-- hardware/monitors.nix injects into the Nix side.

local M = {}

M.main_mod = "SUPER"

M.programs = {
  terminal = os.getenv("HYPR_BACKUP_TERMINAL") or "kitty",
  launcher = os.getenv("HYPR_BACKUP_LAUNCHER") or "anyrun",
  color_picker = "hyprpicker",
  screenshot = "flameshot gui",
  lock = "hyprlock",
  logout = "wlogout",
  emacs = "emacsclient -c",
}

-- Optional extras that exist only in the backup config (not in hyprlang/).
M.features = {
  flameshot = true,
  wlogout = true,
  hyprlock = true,
  emacs_service = true,
  steam = false, -- gamemode bind (hyprlang/gamemode.nix)
}

M.workspaces = {
  per_monitor = 9,
}

M.input = {
  kb_layout = "us",
  kb_variant = "intl",
  kb_options = "",
  primary_tablet_output = "DP-1",
}

-- Mirrors osConfig.modules.hardware.monitors.displays per host.
M.monitors = {
  desktop = {
    { output = "DP-1", mode = "2560x1080@180", position = "0x0", scale = 1.0 },
    { output = "HDMI-A-1", mode = "1920x1080@180", position = "2560x0", scale = 1.0 },
  },
  laptop = {
    { output = "eDP-1", mode = "2560x1080@180", position = "0x0", scale = 1.0 },
  },
}

M.active_monitor_profile = os.getenv("HYPR_BACKUP_MONITOR_PROFILE") or "desktop"

return M
