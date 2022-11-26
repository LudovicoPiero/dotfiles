{pkgs, ...}: {
  programs.mako = {
    enable = true;
    anchor = "top-right";
    backgroundColor = "#1E1E2E";
    borderColor = "#89B4FA";
    borderRadius = 6;
    borderSize = 2;
    defaultTimeout = 3;
    font = "JetBrains Mono Nerd Font 10";
    height = 100;
    width = 300;
    iconPath = "~/.config/mako/icons";
    layer = "overlay";
    margin = "20";
    markup = true;
    maxIconSize = 48;
    maxVisible = 5;
    padding = "15";
    progressColor = "over #313244";
    sort = "-time";
    textColor = "#CDD6F4";

    extraConfig = ''
      [urgency=low]
      border-color=#2D3039
      default-timeout=2000

      [urgency=normal]
      border-color=#89DCEB
      default-timeout=5000

      [urgency=high]
      border-color=#FAB387
      default-timeout=5000
    '';
  };

  xdg.configFile = {
    "mako/icons" = {
      source = ./icons;
    };
  };
}
