{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkOption types mkIf;
  cfg = config.mine.music;
in
{
  options.mine.music = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable music.";
    };
  };

  config = mkIf cfg.enable {
    services.playerctld.enable = true;
    hj = {
      packages = with pkgs; [ rmpc ];
      xdg.config.files."rmpc/config.ron".text = ''
        #![enable(implicit_some)]
        #![enable(unwrap_newtypes)]
        #![enable(unwrap_variant_newtypes)]
        (
            address: "127.0.0.1:6600",
            password: None,
            theme: None,
            cache_dir: "${config.vars.homeDirectory}/.cache/rmpc",
            lyrics_dir: "${config.vars.homeDirectory}/.config/rmpc/lyrics",
            on_song_change: None,
            volume_step: 5,
            max_fps: 30,
            scrolloff: 0,
            wrap_navigation: false,
            enable_mouse: true,
            enable_config_hot_reload: true,
            status_update_interval_ms: 1000,
            select_current_song_on_change: false,
            browser_song_sort: [Disc, Track, Artist, Title],
            album_art: (
                method: Auto,
                max_size_px: (width: 600, height: 600),
                disabled_protocols: ["http://", "https://"],
            ),
        )
      '';

      xdg.config.files."mpd/mpd.conf".text = ''
        music_directory "${config.vars.homeDirectory}/Media/Music"
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

        bind_to_address "127.0.0.1"
        port "6600"
      '';
    };

    services.mpd.enable = lib.mkForce false;
    systemd.user.services.mpd = {
      description = "Music Player Daemon (User Service)";
      after = [
        "pipewire.service"
        "pipewire-pulse.service"
      ];
      wants = [ "pipewire.service" ];
      wantedBy = [ "default.target" ];
      serviceConfig = {
        ExecStart = "${lib.getExe pkgs.mpd} --no-daemon ${config.vars.homeDirectory}/.config/mpd/mpd.conf";
        Restart = "on-failure";
      };
    };

    systemd.user.services.mpdris2 = {
      description = "MPD D-Bus Interface (mpDris2)";
      after = [ "mpd.service" ];
      wants = [ "mpd.service" ];
      wantedBy = [ "default.target" ];
      serviceConfig = {
        ExecStart = "${lib.getExe pkgs.mpdris2}";
        Restart = "on-failure";
      };
    };

    systemd.user.services.mpd-discord-rpc = {
      description = "the mpd-discord-rpc service";
      after = [ "mpd.service" ];
      wants = [ "mpd.service" ];
      wantedBy = [ "default.target" ];
      serviceConfig = {
        ExecStart = "${lib.getExe pkgs.mpd-discord-rpc}";
        Restart = "on-failure";
      };
    };
  };
}
