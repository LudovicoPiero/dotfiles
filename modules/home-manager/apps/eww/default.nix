{
  config,
  pkgs,
  inputs,
  lib,
  ...
}: {
  home.packages = with pkgs; [
    config.wayland.windowManager.hyprland.package
    config.programs.eww.package
    bash
    bc
    blueberry
    bluez
    coreutils
    dbus
    dunst
    findutils
    gawk
    gnused
    gojq
    iwgtk
    light
    networkmanager
    networkmanagerapplet
    pavucontrol
    playerctl
    procps
    pulseaudio
    ripgrep
    socat
    udev
    upower
    util-linux
    wget
    wireplumber
    wlogout
    wofi
  ];
  programs.eww = {
    enable = true;
    package = inputs.eww.packages.${pkgs.system}.eww-wayland;
    # remove nix files
    configDir = lib.cleanSourceWith {
      filter = name: _type: let
        baseName = baseNameOf (toString name);
      in
        !(lib.hasSuffix ".nix" baseName);
      src = lib.cleanSource ./.;
    };
  };
}
