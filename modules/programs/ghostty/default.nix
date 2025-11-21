{
  pkgs,
  config,
  lib,
  ...
}:
let
  inherit (lib) mkOption types mkIf;
  inherit (config.mine.theme.colorScheme) palette;

  cfg = config.mine.ghostty;
in
{
  options.mine.ghostty = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable ghostty terminal emulator";
    };

    font-family = mkOption {
      type = types.str;
      default = "${config.mine.fonts.terminal.name} Semibold";
      description = "Font family for ghostty terminal.";
    };

    font-size = mkOption {
      type = types.str;
      default = "${toString config.mine.fonts.size}";
      description = "Font size for ghostty terminal.";
    };
  };

  config = mkIf config.mine.ghostty.enable {
    hj.packages = with pkgs; [ ghostty ];

    hj.xdg.config.files."ghostty/config" = {
      clobber = true;
      text = ''
        # --- Appearance & Theme ---
        font-family = "${cfg.font-family}"
        font-size = "${cfg.font-size}"

        # Base Colors
        background = #${palette.base00}
        foreground = #${palette.base05}
        cursor-color = #${palette.base05}
        selection-background = #${palette.base02}
        selection-foreground = #${palette.base05}

        # ANSI Colors (0-7)
        palette = 0=#${palette.base00}
        palette = 1=#${palette.base08}
        palette = 2=#${palette.base0B}
        palette = 3=#${palette.base0A}
        palette = 4=#${palette.base0D}
        palette = 5=#${palette.base0E}
        palette = 6=#${palette.base0C}
        palette = 7=#${palette.base05}

        # ANSI Bright Colors (8-15)
        palette = 8=#${palette.base03}
        palette = 9=#${palette.base08}
        palette = 10=#${palette.base0B}
        palette = 11=#${palette.base0A}
        palette = 12=#${palette.base0D}
        palette = 13=#${palette.base0E}
        palette = 14=#${palette.base0C}
        palette = 15=#${palette.base07}

        # --- Window Settings ---
        window-padding-x = 15
        window-padding-y = 15
        window-padding-balance = true
        window-padding-color = "extend"
        window-decoration = "none"
        window-inherit-working-directory = false

        # --- GTK Settings ---
        gtk-single-instance = true
        gtk-tabs-location = "top"
        gtk-wide-tabs = false
        gtk-toolbar-style = "flat"
        gtk-custom-css = "styles/tabs.css"

        # --- Behavior ---
        app-notifications = "false"
        mouse-hide-while-typing = true
        clipboard-read = "allow"
        clipboard-write = "allow"
        clipboard-paste-protection = false
        shell-integration-features = "no-cursor"
        cursor-style = "block"
        cursor-style-blink = false

        # --- Keybinds ---
        # Pane navigation (leader = ctrl+a)
        keybind = ctrl+a>h=goto_split:left
        keybind = ctrl+a>j=goto_split:down
        keybind = ctrl+a>k=goto_split:up
        keybind = ctrl+a>l=goto_split:right

        # Splits
        keybind = ctrl+a>v=new_split:down
        keybind = ctrl+a>;=new_split:right

        # Tabs
        keybind = ctrl+a>c=new_tab
        keybind = ctrl+a>1=goto_tab:1
        keybind = ctrl+a>2=goto_tab:2
        keybind = ctrl+a>3=goto_tab:3
        keybind = ctrl+a>4=goto_tab:4
        keybind = ctrl+a>5=goto_tab:5
        keybind = ctrl+a>6=goto_tab:6
        keybind = ctrl+a>7=goto_tab:7
        keybind = ctrl+a>8=goto_tab:8

        # Scrolling lines with Shift+Up / Shift+Down
        keybind = shift+up=scroll_page_lines:-3
        keybind = shift+down=scroll_page_lines:3

        # Reload config
        keybind = ctrl+shift+r=reload_config
      '';
    };
  };
}
