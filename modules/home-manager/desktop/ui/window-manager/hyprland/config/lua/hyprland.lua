-- Backup Hyprland Lua config.
--
-- Parallel port of hyprlang/ (the active Nix config). Not wired into Nix.
-- Copy or link this directory to $XDG_CONFIG_HOME/hypr to try the native
-- Hyprland Lua config loader (Hyprland 0.55+).
--
-- Load order: data/env first, binds last.

require("hypr.monitors").setup()
require("hypr.workspaces").setup()
require("hypr.input").setup()
require("hypr.layout").setup()
require("hypr.misc").setup()
require("hypr.theme").setup()
require("hypr.autostart").setup()
require("hypr.keybindings").setup()
