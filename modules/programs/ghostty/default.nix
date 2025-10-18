{ lib, config, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  inherit (config.mine.theme.colorScheme) palette;

  cfg = config.mine.ghostty;
in
{
  options.mine.ghostty = {
    enable = mkEnableOption "Ghostty Terminal";
  };

  config = mkIf cfg.enable {
    hm =
      { osConfig, ... }:
      {
        programs.ghostty = {
          enable = true;

          settings = {
            font-family = [
              "${config.mine.fonts.terminal.name} Semibold"
              osConfig.mine.fonts.cjk.name
              osConfig.mine.fonts.icon.name
              osConfig.mine.fonts.emoji.name
            ];
            font-size = osConfig.mine.fonts.size;

            # Theme
            background-opacity = osConfig.vars.opacity;
            window-padding-x = 15;
            window-padding-y = 15;
            app-notifications = "false";
            mouse-hide-while-typing = true;
            gtk-single-instance = false;
            gtk-tabs-location = "top";
            gtk-wide-tabs = false;
            gtk-toolbar-style = "flat";

            window-padding-balance = true;
            window-padding-color = "extend";
            window-decoration = "none";
            window-theme = "ghostty";
            window-inherit-working-directory = false;

            clipboard-read = "allow";
            clipboard-write = "allow";
            clipboard-paste-protection = false;

            shell-integration-features = "no-cursor";
            cursor-style = "block";
            cursor-style-blink = false;

            keybind = [
              # Pane navigation (with leader = ctrl+a)
              "ctrl+a>h=goto_split:left"
              "ctrl+a>j=goto_split:down"
              "ctrl+a>k=goto_split:up"
              "ctrl+a>l=goto_split:right"

              # Copy mode
              # "ctrl+a>[=enter_copy_mode"

              # Splits
              "ctrl+a>v=new_split:down"
              "ctrl+a>;=new_split:right"

              # Tabs
              "ctrl+a>c=new_tab"
              "ctrl+a>1=goto_tab:1"
              "ctrl+a>2=goto_tab:2"
              "ctrl+a>3=goto_tab:3"
              "ctrl+a>4=goto_tab:4"
              "ctrl+a>5=goto_tab:5"
              "ctrl+a>6=goto_tab:6"
              "ctrl+a>7=goto_tab:7"
              "ctrl+a>8=goto_tab:8"

              # Send literal Ctrl+A (LEADER + CTRL)
              # "ctrl+a>ctrl+a=text:\\x01"

              # Scrolling lines with Shift+Up / Shift+Down
              "shift+up=scroll_page_lines:-3"
              "shift+down=scroll_page_lines:3"

              # Reload config
              "ctrl+shift+r=reload_config"
            ];

            theme = "custom";
          };

          themes.custom = {
            background = palette.base00;
            foreground = palette.base05;
            cursor-color = palette.base05;
            selection-background = palette.base02;
            selection-foreground = palette.base05;
            palette = with palette; [
              "0=${base00}"
              "1=${base08}"
              "2=${base0B}"
              "3=${base0A}"
              "4=${base0D}"
              "5=${base0E}"
              "6=${base0C}"
              "7=${base05}"
              "8=${base03}"
              "9=${base08}"
              "10=${base0B}"
              "11=${base0A}"
              "12=${base0D}"
              "13=${base0E}"
              "14=${base0C}"
              "15=${base07}"
            ];
          };
        };
      };
  };
}
