{ pkgs, lib, ... }:
let
  _ = lib.getExe;
in
{
  programs.kitty = {
    enable = true;

    shellIntegration.mode = "no-rc no-cursor";

    font = {
      name = lib.mkForce "Iosevka q";
    };

    keybindings = {
      "ctrl+a>c" = "new_tab_with_cwd";
      "ctrl+a>v" = "new_window_with_cwd";
      "alt+k" = "scroll_line_up";
      "alt+j" = "scroll_line_down";
      "alt+t" = "new_tab";
      "ctrl+shift+k" = "scroll_page_up";
      "ctrl+shift+j" = "scroll_page_down";
      "ctrl+shift+f" = "launch --type=overlay --stdin-source=@screen_scrollback ${_ pkgs.dash} -c \"${_ pkgs.fzf} --no-sort --no-mouse --exact -i --tac | ${_ pkgs.kitty} +kitten clipboard\"";

      # Tabs
      "ctrl+a>1" = "goto_tab 1";
      "ctrl+a>2" = "goto_tab 2";
      "ctrl+a>3" = "goto_tab 3";
      "ctrl+a>4" = "goto_tab 4";
      "ctrl+a>5" = "goto_tab 5";
    };

    settings = {
      window_margin_width = 2;

      cursor_shape = "block";
      disable_ligatures = "cursor";
      scrollback_lines = 5000;
      enable_audio_bell = false;
      update_check_interval = 0;
      open_url_with = "xdg-open";
      confirm_os_window_close = 0;

      # Tab bar
      tab_bar_min_tabs = 1;
      tab_bar_edge = "bottom";
      tab_bar_style = "powerline";
      tab_powerline_style = "slanted";
      tab_title_template = "{index}:{title}";
    };
  };
}
