{
  config,
  pkgs,
  inputs,
  ...
}: {
  programs.steam.enable = true;
  programs.gamemode = {
    enable = true;
    settings = {
      custom = {
        start = "${pkgs.libnotify}/bin/notify-send 'GameMode started'";
        end = "${pkgs.libnotify}/bin/notify-send 'GameMode ended'";
      };
    };
  };
  home-manager.users.${config.vars.username} = {
    home.packages = with inputs.nix-gaming.packages.${pkgs.system};
      [wine-tkg]
      ++ (with pkgs; [
        gamescope
        mangohud
        lutris
        protonup-qt
        inputs.self.packages.${pkgs.system}.TLauncher
      ]);

    xdg.configFile."MangoHud/MangoHud.conf".text = ''
      gpu_stats
      cpu_stats
      fps
      frame_timing = 0
      throttling_status = 0
      position=top-right
    '';
  };
}
