{
  pkgs,
  lib,
  ...
}: {
    home.packages = [
        pkgs.wezterm
    ];

    xdg.configFile."wezterm/wezterm.lua".source = ./wezterm.lua;
  # xdg.configFile."wezterm/wezterm.lua".text = ''
  #   local wezterm = require("wezterm")
  #
  #   return {
  #   	font = wezterm.font_with_fallback({
  #   		"UbuntuMono Nerd Font",
  #   		"Noto Color Emoji",
  #   	}),
  #   	font_size = 13.0,
  #   	window_background_opacity = 0.9,
  #
  #   	color_scheme = "Catppuccin Mocha",
  #   	window_frame = {
  #   		font = wezterm.font_with_fallback({
  #   			"FiraCode Nerd Font",
  #   			"Noto Color Emoji",
  #   		}),
  #   		font_size = 12.0,
  #   		active_titlebar_bg = "#333333",
  #   		inactive_titlebar_bg = "#333333",
  #   	},
  #
  #   	colors = {
  #   		tab_bar = {
  #   			-- The color of the inactive tab bar edge/divider
  #   			inactive_tab_edge = "#575757",
  #   		},
  #   	},
  #
  #   	exit_behavior = "Close",
  #   	leader = { key = "a", mods = "CTRL", timeout_milliseconds = 1000 },
  #   	keys = {
  #   		{ key = "UpArrow", mods = "SHIFT", action = wezterm.action({ ScrollToPrompt = -1 }) },
  #   		{ key = "DownArrow", mods = "SHIFT", action = wezterm.action({ ScrollToPrompt = 1 }) },
  #
  #   		{ key = "h", mods = "LEADER", action = wezterm.action({ ActivatePaneDirection = "Left" }) },
  #   		{ key = "l", mods = "LEADER", action = wezterm.action({ ActivatePaneDirection = "Right" }) },
  #   		{ key = "j", mods = "LEADER", action = wezterm.action({ ActivatePaneDirection = "Down" }) },
  #   		{ key = "k", mods = "LEADER", action = wezterm.action({ ActivatePaneDirection = "Up" }) },
  #   		{ key = ";", mods = "LEADER", action = wezterm.action({ SplitHorizontal = { domain = "CurrentPaneDomain" } }) },
  #   		{ key = "v", mods = "LEADER", action = wezterm.action({ SplitVertical = { domain = "CurrentPaneDomain" } }) },
  #
  #   		-- screen/tmux compat
  #   		{ key = "c", mods = "LEADER", action = wezterm.action({ SpawnTab = "CurrentPaneDomain" }) },
  #
  #   		{ key = "1", mods = "LEADER", action = wezterm.action({ ActivateTab = 0 }) },
  #   		{ key = "2", mods = "LEADER", action = wezterm.action({ ActivateTab = 1 }) },
  #   		{ key = "3", mods = "LEADER", action = wezterm.action({ ActivateTab = 2 }) },
  #   		{ key = "4", mods = "LEADER", action = wezterm.action({ ActivateTab = 3 }) },
  #   		{ key = "5", mods = "LEADER", action = wezterm.action({ ActivateTab = 4 }) },
  #   		{ key = "6", mods = "LEADER", action = wezterm.action({ ActivateTab = 5 }) },
  #   		{ key = "7", mods = "LEADER", action = wezterm.action({ ActivateTab = 6 }) },
  #   		{ key = "8", mods = "LEADER", action = wezterm.action({ ActivateTab = 7 }) },
  #   		{ key = "9", mods = "LEADER", action = wezterm.action({ ActivateTab = -1 }) },
  #   		-- Send "CTRL-A" to the terminal when pressing CTRL-A, CTRL-A
  #   		{ key = "b", mods = "LEADER|CTRL", action = wezterm.action({ SendString = "\x02" }) },
  #   	},
  #   }
  # '';
}
