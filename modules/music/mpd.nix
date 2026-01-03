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

  cfg = config.mine.music.mpd;
  homeDir = config.mine.vars.homeDirectory;
  xdgConfig = config.hj.xdg.config.directory;
  xdgState = config.hj.xdg.state.directory;
in
{
  options.mine.music.mpd = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable MPD backend (Daemon, scribbler, discord-rpc).";
    };
  };

  config = mkIf cfg.enable {
    services = {
      # Secrets (TODO)
      # sops.secrets = {
      #   "scrobble/lastfm" = { };
      # };

      # System Services
      playerctld.enable = true;

      # Disable system-wide MPD to use the user-service defined below
      mpd.enable = mkForce false;

      mpdscribble = {
        enable = true;
        host = "localhost";
        port = 6600;
        # endpoints = {
        #   "last.fm" = {
        #     username = "ludovicopiero";
        #     # TODO: Re-enable secret when sops is configured
        #     # passwordFile = config.sops.secrets."scrobble/lastfm".path;
        #   };
        # };
      };
    };

    # User Configuration (via hj)
    hj.xdg.config.files = {
      # -- MPD Config --
      "mpd/mpd.conf".text = ''
        music_directory      "${homeDir}/Media/Music"
        playlist_directory   "${xdgConfig}/mpd/playlists"
        state_file           "${xdgState}/mpd/state"
        sticker_file         "${xdgState}/mpd/sticker.sql"
        db_file              "${xdgState}/mpd/database"

        auto_update          "yes"
        volume_normalization "no"
        restore_paused       "yes"
        filesystem_charset   "UTF-8"
        replaygain           "off"
        audio_buffer_size    "8192"

        audio_output {
          type       "pipewire"
          name       "PipeWire"
          format     "44100:24:2"
        }

        audio_output {
          type       "fifo"
          name       "Visualiser"
          path       "/tmp/mpd.fifo"
          format     "44100:16:2"
        }

        audio_output {
          type       "httpd"
          name       "lossless"
          encoder    "flac"
          port       "8000"
          max_clients "8"
          format     "44100:16:2"
        }

        bind_to_address "127.0.0.1"
        port            "6600"
      '';
    };

    # User Services
    systemd = {
      # MPD Daemon
      user.services.mpd = {
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

      # MPRIS Bridge (for media keys/widgets)
      user.services.mpdris2 = {
        description = "MPD D-Bus Interface (mpDris2)";
        after = [ "mpd.service" ];
        wants = [ "mpd.service" ];
        wantedBy = [ "default.target" ];
        serviceConfig = {
          ExecStart = getExe pkgs.mpdris2;
          Restart = "on-failure";
        };
      };

      # Discord RPC
      user.services.mpd-discord-rpc = {
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
  };
}
