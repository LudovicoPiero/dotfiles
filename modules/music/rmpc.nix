{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkOption types mkIf;

  cfg = config.mine.music.rmpc;
  xdgConfig = config.hj.xdg.config.directory;
  c = config.mine.theme.colors;
in
{
  options.mine.music.rmpc = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable RMPC (MPD Client) and configuration.";
    };
  };

  config = mkIf cfg.enable {
    hj.packages = [ pkgs.rmpc ];

    hj.xdg.config.files = {
      # -- RMPC Config --
      "rmpc/config.ron".text = ''
        #![enable(implicit_some)]
        #![enable(unwrap_newtypes)]
        #![enable(unwrap_variant_newtypes)]
        (
          address: "127.0.0.1:6600",
          cache_dir: Some("${config.hj.xdg.cache.directory}/rmpc"),
          lyrics_dir: Some("${xdgConfig}/rmpc/lyrics"),
          theme: "onedark_deep",
          volume_step: 5,
          max_fps: 30,
          scrolloff: 0,
          wrap_navigation: false,
          enable_mouse: true,
          status_update_interval_ms: 1000,
          select_current_song_on_change: false,
          browser_column_widths: [20, 38, 42],
          album_art: (
            method: Auto,
            max_size_px: (width: 900, height: 900),
            disabled_protocols: ["http://", "https://"],
            vertical_align: Top,
            horizontal_align: Center,
          ),
          keybinds: (
            global: {
              ":":        CommandMode,
              ",":        VolumeDown,
              "s":        Stop,
              ".":        VolumeUp,
              "<Tab>":    NextTab,
              "<S-Tab>": PreviousTab,
              "1":        SwitchToTab("Queue"),
              "2":        SwitchToTab("Artists"),
              "3":        SwitchToTab("Albums"),
              "4":        SwitchToTab("Search"),
              "5":        SwitchToTab("Directories"),
              "6":        SwitchToTab("Lyrics"),
              "q":        Quit,
              ">":        NextTrack,
              "p":        TogglePause,
              "<":        PreviousTrack,
              "f":        SeekForward,
              "z":        ToggleRepeat,
              "x":        ToggleRandom,
              "c":        ToggleConsume,
              "v":        ToggleSingle,
              "b":        SeekBack,
              "~":        ShowHelp,
              "I":        ShowCurrentSongInfo,
              "O":        ShowOutputs,
              "P":        ShowDecoders,
            },
            navigation: {
              "k":          Up,
              "j":          Down,
              "h":          Left,
              "l":          Right,
              "<Up>":       Up,
              "<Down>":     Down,
              "<Left>":     Left,
              "<Right>":    Right,
              "<C-k>":      PaneUp,
              "<C-j>":      PaneDown,
              "<C-h>":      PaneLeft,
              "<C-l>":      PaneRight,
              "<C-u>":      UpHalf,
              "N":          PreviousResult,
              "a":          Add,
              "A":          AddAll,
              "r":          Rename,
              "n":          NextResult,
              "g":          Top,
              "<Space>":    Select,
              "<C-Space>":  InvertSelection,
              "G":          Bottom,
              "<CR>":       Confirm,
              "i":          FocusInput,
              "J":          MoveDown,
              "<C-d>":      DownHalf,
              "/":          EnterSearch,
              "<C-c>":      Close,
              "<Esc>":      Close,
              "K":          MoveUp,
              "D":          Delete,
            },
            queue: {
              "D":         DeleteAll,
              "<CR>":      Play,
              "<C-s>":     Save,
              "a":         AddToPlaylist,
              "d":         Delete,
              "i":         ShowInfo,
              "C":         JumpToCurrent,
            },
          ),
          search: (
            case_sensitive: false,
            mode: Contains,
            tags: [
              (value: "any",          label: "Any Tag"),
              (value: "artist",       label: "Artist"),
              (value: "album",        label: "Album"),
              (value: "title",        label: "Title"),
              (value: "filename",     label: "Filename"),
              (value: "genre",        label: "Genre"),
              (value: "albumartist", label: "Featured"),
            ],
          ),
          artists: (
            album_display_mode: SplitByDate,
            album_sort_by: Date,
          ),
          tabs: [
            (name: "Queue", pane: Split(direction: Horizontal, panes: [(size: "20%", pane: Pane(AlbumArt)), (size: "80%", pane: Pane(Queue))])),
            (name: "Artists", pane: Pane(Artists)),
            (name: "Albums", pane: Pane(Albums)),
            (name: "Search", pane: Pane(Search)),
            (name: "Directories", pane: Pane(Directories)),
            (name: "Lyrics", pane: Split(direction: Vertical, panes: [(size: "25%", pane: Pane(AlbumArt)), (size: "70%", pane: Pane(Lyrics), vertical_align: Bottom)])),
          ],
        )
      '';

      # -- RMPC Theme (Dynamic) --
      "rmpc/themes/onedark_deep.ron".text = ''
        #![enable(implicit_some)]
        #![enable(unwrap_newtypes)]
        #![enable(unwrap_variant_newtypes)]
        (
          default_album_art_path: None,
          show_song_table_header: true,
          draw_borders: true,
          browser_column_widths: [20, 38, 42],
          background_color: "${c.base00}",
          text_color: "${c.base05}",
          header_background_color: None,
          modal_background_color: "${c.base01}",
          tab_bar: (
            enabled: true,
            active_style: (fg: "${c.base00}", bg: "${c.base0D}", modifiers: "Bold"),
            inactive_style: (),
          ),
          highlighted_item_style: (fg: "${c.base0E}", modifiers: "Bold"),
          current_item_style: (fg: "${c.base00}", bg: "${c.base0D}", modifiers: "Bold"),
          borders_style: (fg: "${c.base0D}"),
          highlight_border_style: (fg: "${c.base0D}"),
          symbols: (song: "󰎇", dir: "󰉋", marker: " ", ellipsis: "..."),
          progress_bar: (
            symbols: ["", "", " "],
            track_style: (fg: "${c.base02}"),
            elapsed_style: (fg: "${c.base0D}"),
            thumb_style: (fg: "${c.base0D}", bg: "${c.base02}"),
          ),
          scrollbar: (
            symbols: ["│", "█", "▲", "▼"],
            track_style: (),
            ends_style: (),
            thumb_style: (fg: "${c.base0D}"),
          ),
          song_table_format: [
            (prop: (kind: Property(Artist), default: (kind: Text("Unknown"))), width: "15%"),
            (prop: (kind: Property(Title), default: (kind: Text("Unknown"))), width: "55%"),
            (prop: (kind: Property(Album), style: (fg: "${c.base05}"), default: (kind: Text("Unknown Album"), style: (fg: "${c.base05}"))), width: "20%"),
            (prop: (kind: Sticker("playCount"), default: (kind: Text("0"))), width: "9", alignment: Right, label: "Playcount"),
            (prop: (kind: Property(Duration), default: (kind: Text("-"))), width: "10%", alignment: Right),
          ],
          layout: Split(
            direction: Vertical,
            panes: [
              (pane: Pane(Header), size: "2"),
              (pane: Pane(Tabs), size: "3"),
              (pane: Pane(TabContent), size: "100%"),
              (pane: Pane(ProgressBar), size: "1"),
            ],
          ),
          header: (
            rows: [
              (
                left: [
                  (kind: Text("["), style: (fg: "${c.base0A}", modifiers: "Bold")),
                  (kind: Property(Status(StateV2(playing_label: "Playing", paused_label: "Paused", stopped_label: "Stopped"))), style: (fg: "${c.base0A}", modifiers: "Bold")),
                  (kind: Text("]"), style: (fg: "${c.base0A}", modifiers: "Bold"))
                ],
                center: [
                  (kind: Property(Song(Title)), style: (modifiers: "Bold"), default: (kind: Text("No Song"), style: (modifiers: "Bold")))
                ],
                right: [
                  (kind: Property(Widget(Volume)), style: (fg: "${c.base0D}"))
                ]
              ),
              (
                left: [
                  (kind: Property(Status(Elapsed))),
                  (kind: Text(" / ")),
                  (kind: Property(Status(Duration))),
                  (kind: Text(" (")),
                  (kind: Property(Status(Bitrate))),
                  (kind: Text(" kbps)"))
                ],
                center: [
                  (kind: Property(Song(Artist)), style: (fg: "${c.base0A}", modifiers: "Bold"), default: (kind: Text("Unknown"), style: (fg: "${c.base0A}", modifiers: "Bold"))),
                  (kind: Text(" - ")),
                  (kind: Property(Song(Album)), default: (kind: Text("Unknown Album")))
                ],
                right: [
                  (
                    kind: Property(Widget(States(active_style: (fg: "${c.base05}", modifiers: "Bold"), separator_style: (fg: "${c.base05}")))),
                    style: (fg: "${c.base03}")
                  ),
                ]
              ),
            ],
          ),
          browser_song_format: [
            (kind: Group([(kind: Property(Track)), (kind: Text(" "))])),
            (kind: Group([(kind: Property(Artist)), (kind: Text(" - ")), (kind: Property(Title))]), default: (kind: Property(Filename))),
          ],
        )
      '';
    };
  };
}
