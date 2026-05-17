-- Backup Hyprland Lua config.
--
-- This file intentionally stays outside the active Nix/Home Manager wiring.
-- Copy or link this directory to $XDG_CONFIG_HOME/hypr when you want to try the
-- native Hyprland Lua config loader.

require("hypr.monitors").setup()
require("hypr.misc").setup()
require("hypr.theme").setup()
require("hypr.layout").setup()
require("hypr.input").setup()
require("hypr.autostart").setup()
require("hypr.keybindings").setup()
