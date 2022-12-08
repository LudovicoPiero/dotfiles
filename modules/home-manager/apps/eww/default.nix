{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  #https://github.com/fufexan/dotfiles/blob/main/home/programs/eww/default.nix
  programs.eww = {
    enable = true;
    package = inputs.eww.packages.${pkgs.system}.eww-wayland;
    configDir = lib.cleanSourceWith {
      filter = name: _type: let
        baseName = baseNameOf (toString name);
      in
        !(lib.hasSuffix ".nix" baseName);
      src = lib.cleanSource ./.;
    };
  };

  home.packages = with pkgs; [
    pamixer
    brightnessctl
    iwd
  ];

  systemd.user.services.eww = {
    Unit = {
      Description = "Eww Daemon";
      # not yet implemented
      # PartOf = ["tray.target"];
      PartOf = ["graphical-session.target"];
    };
    Service = {
      ExecStart = "${config.programs.eww.package}/bin/eww daemon --no-daemonize";
      Restart = "on-failure";
    };
    Install.WantedBy = ["graphical-session.target"];
  };
  # # configuration
  # home.file.".config/eww/eww.scss".source = ./eww.scss;
  # home.file.".config/eww/eww.yuck".source = ./eww.yuck;

  # # scripts
  # home.file.".config/eww/scripts/battery.sh" = {
  #   source = ./scripts/battery.sh;
  #   executable = true;
  # };

  # home.file.".config/eww/scripts/wifi.sh" = {
  #   source = ./scripts/wifi.sh;
  #   executable = true;
  # };

  # home.file.".config/eww/scripts/brightness.sh" = {
  #   source = ./scripts/brightness.sh;
  #   executable = true;
  # };

  # home.file.".config/eww/scripts/workspaces.sh" = {
  #   source = ./scripts/workspaces.sh;
  #   executable = true;
  # };

  # home.file.".config/eww/scripts/workspaces.lua" = {
  #   source = ./scripts/workspaces.lua;
  #   executable = true;
  # };
}
