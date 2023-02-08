{
  config,
  pkgs,
  ...
}: {
  home-manager.users."${config.vars.username}" = {
    home.packages = with pkgs; [
      wofi
      yad
    ];

    xdg.configFile = {
      "wofi" = {
        source = ./.;
        recursive = true;
      };
    };
  };
}
