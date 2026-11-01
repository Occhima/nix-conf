-- hypr/options.lua — single source of truth for the backup config.
-- Values mirror hyprlang/*.nix; monitor/workspace data mirrors what
-- hardware/monitors.nix injects into the Nix side.

local M = {}

M.main_mod = "SUPER"

M.programs = {
  terminal = os.getenv("HYPR_BACKUP_TERMINAL") or "ghostty",
  color_picker = "hyprpicker",
  screenshot = "flameshot gui",
  lock = "hyprlock",
  logout = "wlogout",
  emacs = "emacsclient -c",
  quickshell = "qs -c guernica-ukishima ipc call guernica-island",
}

-- Store paths the Nix side injects; unset means the feature falls back.
M.plugins = {
  hy3 = os.getenv("HYPR_BACKUP_HY3"),
  split_monitor_workspaces = os.getenv("HYPR_BACKUP_SPLIT_MONITOR_WORKSPACES"),
}

-- Optional extras that exist only in the backup config (not in hyprlang/).
M.features = {
  flameshot = true,
  wlogout = true,
  hyprlock = true,
  emacs_service = true,
  guernica_shell = true,
  steam = false, -- gamemode bind (hyprlang/gamemode.nix)
}

M.workspaces = {
  per_monitor = 9,
}

M.input = {
  kb_layout = "us,br",
  kb_variant = "intl,abnt2",
  kb_options = "grp:alt_shift_toggle",
  primary_tablet_output = "DP-1",
}

-- Mirrors osConfig.modules.hardware.monitors.displays per host.
M.monitors = {
  desktop = {
    { output = "DP-1", mode = "2560x1080@180", position = "0x0", scale = 1.0, transform = 0 },
    { output = "HDMI-A-1", mode = "1920x1080@180", position = "2560x0", scale = 1.0, transform = 0 },
  },
  laptop = {
    { output = "eDP-1", mode = "2560x1080@180", position = "0x0", scale = 1.0, transform = 0 },
  },
}

M.active_monitor_profile = os.getenv("HYPR_BACKUP_MONITOR_PROFILE") or "desktop"

return M
