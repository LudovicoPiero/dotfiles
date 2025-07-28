{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.mine.ncmpcpp;
in
{
  options.mine.ncmpcpp.enable = mkEnableOption "ncmpcpp";

  config = mkIf cfg.enable {
    hm =
      { config, ... }:
      {
        programs.ncmpcpp = {
          enable = true;

          package =
            (pkgs.ncmpcpp.override {
              outputsSupport = true;
              visualizerSupport = false;
              clockSupport = true;
              taglibSupport = true;
            }).overrideAttrs
              (old: {
                configureFlags = (old.configureFlags or [ ]) ++ [
                  (pkgs.lib.withFeatureAs true "boost" pkgs.boost.dev)
                ];
              });

          mpdMusicDir = config.services.mpd.musicDirectory;

          settings = {
            # Miscelaneous
            ncmpcpp_directory = "${config.xdg.configHome}/ncmpcpp";

            mpd_host = "localhost";
            mpd_port = "6600";

            # VISUALIZER
            # ---
            visualizer_data_source = "/tmp/mpd.fifo";
            visualizer_output_name = "Visualizer";
            visualizer_in_stereo = "no";
            visualizer_fps = "60";
            visualizer_type = "wave";
            visualizer_look = "∗▐";
            visualizer_color = "199,200,201,202,166,130,94,58,22";
            visualizer_spectrum_smooth_look = "yes";

            # GENERAL
            # ---
            lyrics_directory = "${config.xdg.configHome}/ncmpcpp/lyrics";
            connected_message_on_startup = "yes";
            cyclic_scrolling = "yes";
            mouse_support = "yes";
            mouse_list_scroll_whole_page = "yes";
            lines_scrolled = "1";
            message_delay_time = "1";
            playlist_shorten_total_times = "yes";
            playlist_display_mode = "columns";
            browser_display_mode = "columns";
            search_engine_display_mode = "columns";
            playlist_editor_display_mode = "columns";
            autocenter_mode = "yes";
            centered_cursor = "yes";
            user_interface = "alternative";
            follow_now_playing_lyrics = "yes";
            locked_screen_width_part = "50";
            ask_for_locked_screen_width_part = "yes";
            display_bitrate = "no";
            external_editor = "nvim";
            main_window_color = "default";
            startup_screen = "playlist";

            # PROGRESS BAR
            # ---
            progressbar_look = "━━━";
            #progressbar_look = "▃▃▃";
            progressbar_elapsed_color = "5";
            progressbar_color = "black";

            # UI VISIBILITY
            # ---
            header_visibility = "no";
            statusbar_visibility = "yes";
            titles_visibility = "yes";
            enable_window_title = "yes";

            # COLORS
            # ---
            statusbar_color = "white";
            color1 = "white";
            color2 = "blue";

            # UI APPEARANCE
            # ---
            now_playing_prefix = "$b$2 $7 ";
            now_playing_suffix = "  $/b$8";
            current_item_prefix = "$b$7 $/b$3 ";
            current_item_suffix = "  $8";

            # song_columns_list_format = "(50)[]{t|fr:Title} (0)[magenta]{a}";
            song_columns_list_format = "(30)[]{t|fr:Title} (5)[white]{n} (20)[green]{b} (20)[magenta]{a} (7)[blue]{l}";

            # song_list_format = " {%t $R   $8%a$8}|{%f $R   $8%l$8} $8";
            song_list_format = "{%a - }{%t}|{$8%f$9}$R{$3%l$9}";

            song_status_format = "$b$7[$8󰒫 󰐎 󰓛 󰒬 $7] $7󰝗 {$8 %b }|{$8 %t }|{$8 %f }$7󰉾 $8";

            song_window_title_format = "Now Playing ..";
          };
        };
      };
  };
}
