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
      gpu = {
        apply_gpu_optimisations = "accept-responsibility";
        gpu_device = 0;
        amd_performance_level = "high";
      };
      custom = {
        start = "${pkgs.libnotify}/bin/notify-send 'GameMode started'";
        end = "${pkgs.libnotify}/bin/notify-send 'GameMode ended'";
      };
    };
  };
  home-manager.users.${config.vars.username} = {
    home.packages = with pkgs; [
      # inputs.self.packages.${pkgs.system}.albion-online
      gamescope
      inputs.self.packages.${pkgs.system}.TLauncher
    ];
  };
}
