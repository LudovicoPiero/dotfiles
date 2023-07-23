{...}:
# let
#   inherit (config.vars.colorScheme) colors;
# in
{
  programs.wezterm = {
    enable = true;
    extraConfig = ''
      local wezterm = require("wezterm")
      return {
      	font = wezterm.font_with_fallback({
          "Iosevka q Semibold",
          "Symbols Nerd Font",
      	}),
        font_size = 14.0,
      	window_background_opacity = 0.88,
      	color_scheme = "Catppuccin Mocha",
      	enable_scroll_bar = false,
      	-- enable_tab_bar = false,
      	hide_tab_bar_if_only_one_tab = true,
      	scrollback_lines = 10000,
      	adjust_window_size_when_changing_font_size = false,
      	audible_bell = "Disabled",
      	clean_exit_codes = { 130 },
      	window_padding = {
      		left = 10,
      		right = 10,
      		top = 10,
      		bottom = 10,
      	},
      	check_for_updates = false,
      	default_cursor_style = "SteadyBlock",


      	leader = { key = "a", mods = "CTRL", timeout_milliseconds = 1000 },
      	keys = {
      		{ key = "UpArrow", mods = "SHIFT", action = wezterm.action({ ScrollToPrompt = -1 }) },
      		{ key = "DownArrow", mods = "SHIFT", action = wezterm.action({ ScrollToPrompt = 1 }) },
      		{ key = "h", mods = "LEADER", action = wezterm.action({ ActivatePaneDirection = "Left" }) },
      		{ key = "l", mods = "LEADER", action = wezterm.action({ ActivatePaneDirection = "Right" }) },
      		{ key = "j", mods = "LEADER", action = wezterm.action({ ActivatePaneDirection = "Down" }) },
      		{ key = "k", mods = "LEADER", action = wezterm.action({ ActivatePaneDirection = "Up" }) },
      		{
      			key = ";",
      			mods = "LEADER",
      			action = wezterm.action({
      				SplitHorizontal = { domain = "CurrentPaneDomain" },
      			}),
      		},
      		{
      			key = "v",
      			mods = "LEADER",
      			action = wezterm.action({
      				SplitVertical = { domain = "CurrentPaneDomain" },
      			}),
      		},

      		-- close tabs
      		-- { key = "w", mods = "CTRL", action = wezterm.action({ CloseCurrentTab = { confirm = true } }) },

      		-- screen/tmux compat
      		{ key = "c", mods = "LEADER", action = wezterm.action({ SpawnTab = "CurrentPaneDomain" }) },
      		{ key = "1", mods = "LEADER", action = wezterm.action({ ActivateTab = 0 }) },
      		{ key = "2", mods = "LEADER", action = wezterm.action({ ActivateTab = 1 }) },
      		{ key = "3", mods = "LEADER", action = wezterm.action({ ActivateTab = 2 }) },
      		{ key = "4", mods = "LEADER", action = wezterm.action({ ActivateTab = 3 }) },
      		{ key = "5", mods = "LEADER", action = wezterm.action({ ActivateTab = 4 }) },
      		{ key = "6", mods = "LEADER", action = wezterm.action({ ActivateTab = 5 }) },
      		{ key = "7", mods = "LEADER", action = wezterm.action({ ActivateTab = 6 }) },
      		{ key = "8", mods = "LEADER", action = wezterm.action({ ActivateTab = 7 }) },
      		{ key = "9", mods = "LEADER", action = wezterm.action({ ActivateTab = -1 }) },
      		-- Send "CTRL-A" to the terminal when pressing CTRL-A, CTRL-A
      		{ key = "a", mods = "LEADER|CTRL", action = wezterm.action({ SendString = "\x01" }) },
      	},
      }
    '';
  };
}
