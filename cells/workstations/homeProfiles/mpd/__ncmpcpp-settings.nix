# Source: https://github.com/NotAShelf/nyx/blob/bb7fa566897bf6df5087d2253aedb1ca0363248a/homes/notashelf/programs/media/ncmpcpp/settings.nix
{ config, ... }:
{
  programs.ncmpcpp.settings = {
    # Miscelaneous
    ncmpcpp_directory = "${config.xdg.configHome}/ncmpcpp";
    ignore_leading_the = true;
    external_editor = "nvim";
    message_delay_time = 1;
    playlist_disable_highlight_delay = 2;
    autocenter_mode = "yes";
    centered_cursor = "yes";
    allow_for_physical_item_deletion = "no";
    lines_scrolled = "0";
    follow_now_playing_lyrics = "yes";
    lyrics_fetchers = "musixmatch";

    # visualizer
    visualizer_data_source = "/tmp/mpd.fifo";
    visualizer_output_name = "mpd_visualizer";
    visualizer_type = "ellipse";
    visualizer_in_stereo = "yes";
    visualizer_look = "●●";
    visualizer_color = "blue, green";

    # appearance
    colors_enabled = "yes";
    playlist_display_mode = "columns";
    user_interface = "classic";
    volume_color = "white";

    # window
    song_window_title_format = "Music";
    statusbar_visibility = "no";
    header_visibility = "no";
    titles_visibility = "no";
    # progress bar
    progressbar_look = "▂▂▂";
    progressbar_color = "black";
    progressbar_elapsed_color = "yellow";

    # Alternative UI
    alternative_ui_separator_color = "black";
    alternative_header_first_line_format = "$b$5«$/b$5« $b$8{%t}|{%f}$/b $5»$b$5»$/b";
    alternative_header_second_line_format = "{$b{$2%a$9}{ - $7%b$9}{ ($2%y$9)}}|{%D}";

    # song list
    song_status_format = "$7%t";
    song_list_format = "$(008)%t$R  $(247)%a$R$5  %l$8";
    song_columns_list_format = "(53)[blue]{tr} (45)[blue]{a}";

    current_item_prefix = "$b$2| ";
    current_item_suffix = "$/b$5";

    now_playing_prefix = "$b$5| ";
    now_playing_suffix = "$/b$5";

    song_library_format = "{{%a - %t} (%b)}|{%f}";

    # colors
    main_window_color = "blue";

    current_item_inactive_column_prefix = "$b$5";
    current_item_inactive_column_suffix = "$/b$5";

    color1 = "white";
    color2 = "red";
  };
}
