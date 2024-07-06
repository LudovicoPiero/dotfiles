{ config, pkgs, ... }:
{
  imports = [
    ./__mpd-settings.nix
    ./__ncmpcpp-bindings.nix
    ./__ncmpcpp-settings.nix
  ];

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
    };
  };

  programs = {
    ncmpcpp = {
      enable = true;
      package = pkgs.ncmpcpp.override { visualizerSupport = true; };
      mpdMusicDir = config.services.mpd.musicDirectory;
    };
  };
}
