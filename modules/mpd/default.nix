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
    hj = {
      packages = with pkgs; [
        fooyin
        mpd
      ];

      files = {
        ".config/mpd/mpd.conf".text = ''
          music_directory "${config.vars.homeDirectory}/Media/Music"
          state_file "${config.vars.homeDirectory}/.local/state/mpd/state"
          sticker_file "${config.vars.homeDirectory}/.local/state/mpd/sticker.sql"

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

    systemd.user.services.mpd = {
      enable = true;
      description = "MPD (Music Player Daemon)";
      after = [
        "network.target"
        "sound.target"
      ];
      wantedBy = [ "default.target" ];
      serviceConfig = {
        Type = "simple";
        Restart = "always";
        ExecStart = "${lib.getExe pkgs.mpd} --no-daemon";
      };
    };
  };
}
