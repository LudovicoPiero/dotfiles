{ inputs, pkgs, ... }: {
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
  ];

  home.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    MOZ_ENABLE_WAYLAND = "1";
  };

  home.file = {
    hyprland = {
      source = ./.;
      target = ".config/hypr";
      onChange = "hyprctl reload";
      recursive = true;
    };
  };
}
