{pkgs, ...}: {
  programs.kitty = {
    enable = true;
    extraConfig = ''
      font_family        FiraCode Nerd Font
      bold_font        auto
      italic_font      auto
      bold_italic_font auto
      font_size 11.0
      font_features FiraCode Nerd Font +cv01 +cv02 +cv12 +ss05 +ss04 +ss03 +cv31 +cv29 +cv24 +cv25 +cv26 +ss07 +zero +onum
      scrollback_lines 100
      window_border_width 1px
      confirm_os_window_close 0
      tab_bar_edge bottom
      tab_bar_style powerline
      tab_bar_min_tabs 1
      tab_powerline_style slanted
      tab_title_template   {title}{' :{}:'.format(num_windows) if num_windows > 1 else ''\}
      kitty_mod ctrl+shift

      # The basic colors
      foreground              #CDD6F4
      background              #1E1E2E
      selection_foreground    #1E1E2E
      selection_background    #F5E0DC
      background_opacity	0.88
      # Cursor colors
      cursor                  #F5E0DC
      cursor_text_color       #1E1E2E
      # URL underline color when hovering with mouse
      url_color               #F5E0DC
      # Kitty window border colors
      active_border_color     #B4BEFE
      inactive_border_color   #6C7086
      bell_border_color       #F9E2AF
      # OS Window titlebar colors
      wayland_titlebar_color system
      macos_titlebar_color system
      # Tab bar colors
      active_tab_foreground   #11111B
      active_tab_background   #CBA6F7
      inactive_tab_foreground #CDD6F4
      inactive_tab_background #181825
      tab_bar_background      #11111B
      # Colors for marks (marked text in the terminal)
      mark1_foreground #1E1E2E
      mark1_background #B4BEFE
      mark2_foreground #1E1E2E
      mark2_background #CBA6F7
      mark3_foreground #1E1E2E
      mark3_background #74C7EC
      # black
      color0 #45475A
      color8 #585B70
      # red
      color1 #F38BA8
      color9 #F38BA8
      # green
      color2  #A6E3A1
      color10 #A6E3A1
      # yellow
      color3  #F9E2AF
      color11 #F9E2AF
      # blue
      color4  #89B4FA
      color12 #89B4FA
      # magenta
      color5  #F5C2E7
      color13 #F5C2E7
      # cyan
      color6  #94E2D5
      color14 #94E2D5
      # white
      color7  #BAC2DE
      color15 #A6ADC8
    '';
  };
}
