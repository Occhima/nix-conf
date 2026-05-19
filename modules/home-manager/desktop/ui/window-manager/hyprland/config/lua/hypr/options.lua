local M = {}

M.main_mod = "SUPER"

M.programs = {
  terminal = os.getenv("HYPR_BACKUP_TERMINAL") or "kitty",
  launcher = os.getenv("HYPR_BACKUP_LAUNCHER") or "anyrun",
  browser = os.getenv("BROWSER") or "firefox",
  color_picker = "hyprpicker",
  clipboard_menu = "clipcat-menu --rofi-menu-length 10",
  screenshot = "flameshot gui",
  lock = "hyprlock",
  logout = "wlogout",
  emacs = "emacsclient -c",
}

M.features = {
  rofi = false,
  anyrun = true,
  flameshot = true,
  wlogout = true,
  hyprlock = true,
  emacs_service = true,
  clipboard = false,
  steam = false,
  hyprsplit = false,
  native_workspaces = true,
  split_monitor_workspaces = false,
  hy3 = false,
  compact_theme = false,
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
