local wezterm = require("wezterm")

local DIVIDERS = {
    LEFT = utf8.char(0xe0be),
    RIGHT = utf8.char(0xe0bc),
}

-- custom tab bar
---@diagnostic disable-next-line: unused-local
wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
    local colours = config.resolved_palette.tab_bar

    local active_tab_index = 0
    for _, t in ipairs(tabs) do
        if t.is_active == true then
            active_tab_index = t.tab_index
        end
    end

    local active_bg = config.resolved_palette.ansi[6]
    local active_fg = colours.background
    local inactive_bg = colours.inactive_tab.bg_color
    local inactive_fg = colours.inactive_tab.fg_color
    local new_tab_bg = colours.new_tab.bg_color

    local s_bg, s_fg, e_bg, e_fg

    -- the last tab
    if tab.tab_index == #tabs - 1 then
        if tab.is_active then
            s_bg = active_bg
            s_fg = active_fg
            e_bg = new_tab_bg
            e_fg = active_bg
        else
            s_bg = inactive_bg
            s_fg = inactive_fg
            e_bg = new_tab_bg
            e_fg = inactive_bg
        end
    elseif tab.tab_index == active_tab_index - 1 then
        s_bg = inactive_bg
        s_fg = inactive_fg
        e_bg = active_bg
        e_fg = inactive_bg
    elseif tab.is_active then
        s_bg = active_bg
        s_fg = active_fg
        e_bg = inactive_bg
        e_fg = active_bg
    else
        s_bg = inactive_bg
        s_fg = inactive_fg
        e_bg = inactive_bg
        e_fg = inactive_bg
    end

    local muxpanes = wezterm.mux.get_tab(tab.tab_id):panes()
    local count = #muxpanes == 1 and "" or #muxpanes
    local index = tab.tab_index + 1 .. ": "

    return {
        { Background = { Color = s_bg } },
        { Foreground = { Color = s_fg } },
        {
            Text = " " .. index .. tab.active_pane.title .. fonts.numberStyle(count, "superscript") .. " ",
        },
        { Background = { Color = e_bg } },
        { Foreground = { Color = e_fg } },
        { Text = DIVIDERS.RIGHT },
    }
end)

return {
    font = wezterm.font_with_fallback({
        {
            family = "FiraCode Nerd Font",
            weight = "Regular",
            harfbuzz_features = {
                "cv01",
                "cv02",
                "cv12",
                "ss05",
                "ss04",
                "ss03",
                "cv31",
                "cv29",
                "cv24",
                "cv25",
                "cv26",
                "ss07",
                "zero",
                "onum",
            },
        },
        -- "FiraCode Nerd Font",
        -- "UbuntuMono Nerd Font",
        "Noto Color Emoji",
    }),
    font_size = 11.0,
    window_background_opacity = 0.9,

    color_scheme = "Catppuccin Mocha",
    window_frame = {
        font = wezterm.font_with_fallback({
            {
                family = "FiraCode Nerd Font",
                weight = "Bold",
                harfbuzz_features = {
                    "cv01",
                    "cv02",
                    "cv12",
                    "ss05",
                    "ss04",
                    "ss03",
                    "cv31",
                    "cv29",
                    "cv24",
                    "cv25",
                    "cv26",
                    "ss07",
                    "zero",
                    "onum",
                },
            },
            "Noto Color Emoji",
        }),
        font_size = 10.0,
        -- active_titlebar_bg = "#333333",
        -- inactive_titlebar_bg = "#333333",
    },


    -- colors = {
    --     tab_bar = {
    --         -- The color of the inactive tab bar edge/divider
    --         inactive_tab_edge = "#575757",
    --     },
    -- },

    exit_behavior = "Close",
    leader = { key = "a", mods = "CTRL", timeout_milliseconds = 1000 },
    keys = {
        { key = "UpArrow", mods = "SHIFT", action = wezterm.action({ ScrollToPrompt = -1 }) },
        { key = "DownArrow", mods = "SHIFT", action = wezterm.action({ ScrollToPrompt = 1 }) },

        { key = "h", mods = "LEADER", action = wezterm.action({ ActivatePaneDirection = "Left" }) },
        { key = "l", mods = "LEADER", action = wezterm.action({ ActivatePaneDirection = "Right" }) },
        { key = "j", mods = "LEADER", action = wezterm.action({ ActivatePaneDirection = "Down" }) },
        { key = "k", mods = "LEADER", action = wezterm.action({ ActivatePaneDirection = "Up" }) },
        { key = ";", mods = "LEADER", action = wezterm.action({ SplitHorizontal = { domain = "CurrentPaneDomain" } }) },
        { key = "v", mods = "LEADER", action = wezterm.action({ SplitVertical = { domain = "CurrentPaneDomain" } }) },

        -- close tabs
        { key = "w", mods = "CTRL", action = wezterm.action({ CloseCurrentTab = { confirm = true } }) },

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
        { key = "b", mods = "LEADER|CTRL", action = wezterm.action({ SendString = "\x02" }) },
    },
    -- tab bar
    hide_tab_bar_if_only_one_tab = false,
    tab_bar_at_bottom = true,
    tab_max_width = 32,
    use_fancy_tab_bar = false,
    -- etc.
    adjust_window_size_when_changing_font_size = false,
    audible_bell = "Disabled",
    clean_exit_codes = { 130 },
    enable_scroll_bar = false,
}
