{ inputs, pkgs, config, lib, ... }: {
  home.packages = with pkgs; [
    hyprpaper # For Wallpaper
    mako # Notification
    bemenu # Menu
    wofi # Menu
    waybar # Bar
    inputs.hyprland-contrib.packages.${pkgs.system}.grimblast

    # Terminal
    kitty
    foot

    # Utils
    brightnessctl
    grim
    jq
    playerctl
    slurp
    # swayidle
    viewnior
    wl-clipboard
    xdg-user-dirs
    xdg-utils
    yad
    #hyprland (using flakes version)
  ];

  # screen idle
  # https://github.com/fufexan/dotfiles/blob/main/home/wayland/hyprland/default.nix
  # services.swayidle = {
  #   enable = true;
  #   events = [
  #     {
  #       event = "before-sleep";
  #       command = "${pkgs.swaylock-effects}/bin/swaylock -fF";
  #     }
  #     {
  #       event = "lock";
  #       command = "${pkgs.swaylock-effects}/bin/swaylock -fF";
  #     }
  #   ];
  #   timeouts = [
  #     {
  #       timeout = 300;
  #       command = "${config.wayland.windowManager.hyprland.package}/bin/hyprctl dispatch dpms off";
  #       resumeCommand = "${config.wayland.windowManager.hyprland.package}/bin/hyprctl dispatch dpms on";
  #     }
  #     {
  #       timeout = 310;
  #       command = "${pkgs.systemd}/bin/loginctl lock-session";
  #     }
  #   ];
  # };

  # start swayidle as part of hyprland, not sway
  # systemd.user.services.swayidle.Install.WantedBy = lib.mkForce [ "hyprland-session.target" ];

  home.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    MOZ_ENABLE_WAYLAND = "1";
  };

  # Enable Wayland
  # wayland.windowManager.hyprland.enable = true;

  home.file = {
    hyprland = {
      source = ./.;
      target = ".config/hypr";
      onChange = "hyprctl reload";
      recursive = true;
    };
  };
}
