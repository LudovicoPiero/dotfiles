{
  services.mpd.extraConfig = ''
    auto_update           "yes"
    volume_normalization  "yes"
    restore_paused        "yes"
    filesystem_charset    "UTF-8"

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
     type		              "httpd"
     name		              "lossless"
     encoder		          "flac"
     port		              "8000"
     max_clients	        "8"
     mixer_type	          "software"
     format		            "44100:16:2"
    }
  '';
}
