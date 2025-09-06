{ config, lib, ... }:
let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.mine.rmpc;
in
{
  options.mine.rmpc.enable = mkEnableOption "rmpc";

  config = mkIf cfg.enable {
    hm =
      { config, ... }:
      {
        programs.rmpc = {
          enable = true;

          config = ''
            #![enable(implicit_some)]
            #![enable(unwrap_newtypes)]
            #![enable(unwrap_variant_newtypes)]
            (
                address: "127.0.0.1:6600",
                password: None,
                theme: None,
                cache_dir: "${config.xdg.cacheHome}/rmpc",
                lyrics_dir: "${config.xdg.configHome}/rmpc/lyrics",
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
        };
      };
  };
}
