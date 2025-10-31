{
  pkgs,
  config,
  lib,
  ...
}:
{
  options.mine.ghostty = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable ghostty terminal emulator";
    };
  };

  config = lib.mkIf config.mine.ghostty.enable {
    hj.packages = with pkgs; [ ghostty ];

    hj.xdg.config.files."ghostty/config" = {
      clobber = true;
      text = ''
        window-padding-x = 15
        window-padding-y = 15
        app-notifications = "false"
        mouse-hide-while-typing = true
        gtk-single-instance = false
        gtk-tabs-location = "top"
        gtk-wide-tabs = false
        gtk-toolbar-style = "flat"
        gtk-custom-css = "styles/tabs.css"

        window-padding-balance = true
        window-padding-color = "extend"
        window-decoration = "none"
        window-theme = "ghostty"
        window-inherit-working-directory = false

        clipboard-read = "allow"
        clipboard-write = "allow"
        clipboard-paste-protection = false

        shell-integration-features = "no-cursor"
        cursor-style = "block"
        cursor-style-blink = false

        # Pane navigation (with leader = ctrl+a)
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
