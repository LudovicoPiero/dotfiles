{ config, lib, ... }:
let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.mine.mpd;
in
{
  options.mine.mpd.enable = mkEnableOption "MPD (Music Player Daemon)";

  config = mkIf cfg.enable {
    hm =
      { config, ... }:
      {
        # Settings stolen from notashelf's dotfiles xd
        services = {
          mpris-proxy.enable = true;
          mpd-mpris.enable = true;
          mpd-discord-rpc = {
            enable = true;
            settings = {
              format = {
                details = "$title";
                state = "On $album by $artist";
                large_text = "$album";
                small_image = "";
              };
            };
          };

          # MPRIS 2 support to mpd
          mpdris2 = {
            enable = true;
            notifications = true;
            multimediaKeys = true;
            mpd = {
              # for some reason config.xdg.userDirs.music is not a "path" - possibly because it has $HOME in its name?
              inherit (config.services.mpd) musicDirectory;
            };
          };

          mpd = {
            enable = true;
            musicDirectory = "${config.home.homeDirectory}/Media/Music";
            playlistDirectory = "${config.xdg.configHome}/mpd/playlists";
            dbFile = "${config.xdg.stateHome}/mpd/database";

            extraConfig = ''
              state_file "${config.xdg.stateHome}/mpd/state"
              sticker_file "${config.xdg.stateHome}/mpd/sticker.sql"

              auto_update "yes"
              volume_normalization "yes"
              restore_paused "yes"
              filesystem_charset "UTF-8"
              replaygain "track"

              audio_output {
                type                "pipewire"
                name                "PipeWire"
              }

              audio_output {
                type                "fifo"
                name                "Visualiser"
                path                "/tmp/mpd.fifo"
                format              "44100:16:2"
              }

              audio_output {
                type                "httpd"
                name                "lossless"
                encoder             "flac"
                port                "8000"
                max_clients         "8"
                mixer_type          "software"
                format              "44100:16:2"
              }
            '';
          };
        };
      };
  };
}
