{
  config,
  lib,
  pkgs,
  ...
}:
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
        home.packages = with pkgs; [ fooyin ];

        services.mpd = {
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
}
