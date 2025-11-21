{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib)
    mkOption
    types
    mkIf
    getExe
    mkForce
    ;
  inherit (config.mine.theme.colorScheme) palette;

  cfg = config.mine.music;
  homeDir = config.vars.homeDirectory;
  xdgConfig = config.hj.xdg.config.directory;
  xdgState = config.hj.xdg.state.directory;
in
{
  options.mine.music = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable music stack (MPD, mpdscribble, rmpc, discord-rpc).";
    };
  };

  config = mkIf cfg.enable {
    # --- Secrets ---
    sops.secrets = {
      "scrobble/lastfm" = { };
      # "scrobble/listenbrainz" = { }; # FIXME: Re-enable when needed
    };

    # --- System Services ---
    services.playerctld.enable = true;

    # Disable system-wide MPD to use the user-service defined below
    services.mpd.enable = mkForce false;

    services.mpdscribble = {
      enable = true;
      host = "localhost";
      port = 6600;
      endpoints = {
        "last.fm" = {
          username = "ludovicopiero";
          passwordFile = config.sops.secrets."scrobble/lastfm".path;
        };
      };
    };

    # --- User Configuration (via hj) ---
    hj = {
      packages = with pkgs; [ rmpc ];

      xdg.config.files = {
        # -- MPD Config --
        "mpd/mpd.conf".text = ''
          music_directory     "${homeDir}/Media/Music"
          playlist_directory  "${xdgConfig}/mpd/playlists"
          state_file          "${xdgState}/mpd/state"
          sticker_file        "${xdgState}/mpd/sticker.sql"
          db_file             "${xdgState}/mpd/database"

          auto_update         "yes"
          volume_normalization "no"
          restore_paused      "yes"
          filesystem_charset  "UTF-8"
          replaygain          "off"
          audio_buffer_size   "8192"

          audio_output {
            type      "pipewire"
            name      "PipeWire"
            format    "44100:24:2"
          }

          audio_output {
            type      "fifo"
            name      "Visualiser"
            path      "/tmp/mpd.fifo"
            format    "44100:16:2"
          }

          audio_output {
            type      "httpd"
            name      "lossless"
            encoder   "flac"
            port      "8000"
            max_clients "8"
            format    "44100:16:2"
          }

          bind_to_address "127.0.0.1"
          port            "6600"
        '';

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
                ":":       CommandMode,
                ",":       VolumeDown,
                "s":       Stop,
                ".":       VolumeUp,
                "<Tab>":   NextTab,
                "<S-Tab>": PreviousTab,
                "1":       SwitchToTab("Queue"),
                "2":       SwitchToTab("Artists"),
                "3":       SwitchToTab("Albums"),
                "4":       SwitchToTab("Search"),
                "5":       SwitchToTab("Directories"),
                "6":       SwitchToTab("Lyrics"),
                "q":       Quit,
                ">":       NextTrack,
                "p":       TogglePause,
                "<":       PreviousTrack,
                "f":       SeekForward,
                "z":       ToggleRepeat,
                "x":       ToggleRandom,
                "c":       ToggleConsume,
                "v":       ToggleSingle,
                "b":       SeekBack,
                "~":       ShowHelp,
                "I":       ShowCurrentSongInfo,
                "O":       ShowOutputs,
                "P":       ShowDecoders,
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
                "D":       DeleteAll,
                "<CR>":    Play,
                "<C-s>":   Save,
                "a":       AddToPlaylist,
                "d":       Delete,
                "i":       ShowInfo,
                "C":       JumpToCurrent,
              },
            ),
            search: (
              case_sensitive: false,
              mode: Contains,
              tags: [
                (value: "any",         label: "Any Tag"),
                (value: "artist",      label: "Artist"),
                (value: "album",       label: "Album"),
                (value: "title",       label: "Title"),
                (value: "filename",    label: "Filename"),
                (value: "genre",       label: "Genre"),
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

        # -- RMPC Theme (Dynamic: OneDark Deep) --
        "rmpc/themes/onedark_deep.ron".text = ''
          #![enable(implicit_some)]
          #![enable(unwrap_newtypes)]
          #![enable(unwrap_variant_newtypes)]
          (
            default_album_art_path: None,
            show_song_table_header: true,
            draw_borders: true,
            browser_column_widths: [20, 38, 42],
            background_color: "#${palette.base00}",
            text_color: "#${palette.base05}",
            header_background_color: None,
            modal_background_color: "#${palette.base01}",
            tab_bar: (
              enabled: true,
              active_style: (fg: "#${palette.base00}", bg: "#${palette.base0D}", modifiers: "Bold"),
              inactive_style: (),
            ),
            highlighted_item_style: (fg: "#${palette.base0E}", modifiers: "Bold"),
            current_item_style: (fg: "#${palette.base00}", bg: "#${palette.base0D}", modifiers: "Bold"),
            borders_style: (fg: "#${palette.base0D}"),
            highlight_border_style: (fg: "#${palette.base0D}"),
            symbols: (song: "󰎇", dir: "󰉋", marker: " ", ellipsis: "..."),
            progress_bar: (
              symbols: ["", "", " "],
              track_style: (fg: "#${palette.base02}"),
              elapsed_style: (fg: "#${palette.base0D}"),
              thumb_style: (fg: "#${palette.base0D}", bg: "#${palette.base02}"),
            ),
            scrollbar: (
              symbols: ["│", "█", "▲", "▼"],
              track_style: (),
              ends_style: (),
              thumb_style: (fg: "#${palette.base0D}"),
            ),
            song_table_format: [
              (prop: (kind: Property(Artist), default: (kind: Text("Unknown"))), width: "15%"),
              (prop: (kind: Property(Title), default: (kind: Text("Unknown"))), width: "55%"),
              (prop: (kind: Property(Album), style: (fg: "#${palette.base06}"), default: (kind: Text("Unknown Album"), style: (fg: "#${palette.base06}"))), width: "20%"),
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
                    (kind: Text("["), style: (fg: "#${palette.base0A}", modifiers: "Bold")),
                    (kind: Property(Status(StateV2(playing_label: "Playing", paused_label: "Paused", stopped_label: "Stopped"))), style: (fg: "#${palette.base0A}", modifiers: "Bold")),
                    (kind: Text("]"), style: (fg: "#${palette.base0A}", modifiers: "Bold"))
                  ],
                  center: [
                    (kind: Property(Song(Title)), style: (modifiers: "Bold"), default: (kind: Text("No Song"), style: (modifiers: "Bold")))
                  ],
                  right: [
                    (kind: Property(Widget(Volume)), style: (fg: "#${palette.base0D}"))
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
                    (kind: Property(Song(Artist)), style: (fg: "#${palette.base0A}", modifiers: "Bold"), default: (kind: Text("Unknown"), style: (fg: "#${palette.base0A}", modifiers: "Bold"))),
                    (kind: Text(" - ")),
                    (kind: Property(Song(Album)), default: (kind: Text("Unknown Album")))
                  ],
                  right: [
                    (
                      kind: Property(Widget(States(active_style: (fg: "#${palette.base05}", modifiers: "Bold"), separator_style: (fg: "#${palette.base05}")))),
                      style: (fg: "#${palette.base03}")
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

    # --- User Services ---

    # 1. MPD Daemon
    systemd.user.services.mpd = {
      description = "Music Player Daemon (User Service)";
      after = [
        "pipewire.service"
        "pipewire-pulse.service"
      ];
      wants = [ "pipewire.service" ];
      wantedBy = [ "default.target" ];
      serviceConfig = {
        ExecStart = "${getExe pkgs.mpd} --no-daemon ${xdgConfig}/mpd/mpd.conf";
        Restart = "on-failure";
      };
    };

    # 2. MPRIS Bridge (for media keys/widgets)
    systemd.user.services.mpdris2 = {
      description = "MPD D-Bus Interface (mpDris2)";
      after = [ "mpd.service" ];
      wants = [ "mpd.service" ];
      wantedBy = [ "default.target" ];
      serviceConfig = {
        ExecStart = getExe pkgs.mpdris2;
        Restart = "on-failure";
      };
    };

    # 3. Discord RPC
    systemd.user.services.mpd-discord-rpc = {
      description = "MPD Discord RPC";
      after = [ "mpd.service" ];
      wants = [ "mpd.service" ];
      wantedBy = [ "default.target" ];
      serviceConfig = {
        ExecStart = getExe pkgs.mpd-discord-rpc;
        Restart = "on-failure";
      };
    };
  };
}
