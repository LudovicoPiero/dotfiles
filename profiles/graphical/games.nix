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
    home.packages = with pkgs; [
      gamescope
      mangohud
      inputs.self.packages.${pkgs.system}.TLauncher
    ];
  };
}
