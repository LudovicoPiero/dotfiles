{ pkgs, ... }: {
  services = {
    displayManager.sddm.enable = true;
    displayManager.sddm.wayland.enable = true;

    gvfs.enable = true; # Mount, trash, and other functionalities
    tumbler.enable = true; # Thumbnail support for images

    # Use dbus-broker
    dbus.implementation = "broker";

    pipewire = {
      enable = true;
      pulse.enable = true;
    };
    gnome.gnome-keyring.enable = true;
  };

  programs = {
    firefox.enable = true;
    thunar = {
      enable = true;
      plugins = with pkgs; [
        thunar-archive-plugin
        thunar-volman
      ];
    };
  };

  security.polkit.enable = true;
  security.pam.services = {
    swaylock.enableGnomeKeyring = true;
    sddm.enableGnomeKeyring = true;
  };

  fonts = {
    packages = with pkgs; [
      jetbrains-mono
      noto-fonts-color-emoji
      nerd-fonts.symbols-only
    ];

    fontconfig = {
      enable = true;
      defaultFonts = {
        monospace = [
          "JetBrains Mono"
          "Symbols Nerd Font"
          "Noto Color Emoji"
        ];
        sansSerif = [
          "DejaVu Sans"
          "Symbols Nerd Font"
          "Noto Color Emoji"
        ];
        serif = [
          "DejaVu Serif"
          "Symbols Nerd Font"
          "Noto Color Emoji"
        ];
      };
    };
  };

  environment.systemPackages = with pkgs; [
    wl-clipboard
    mako
    wget
    git
    thunderbird
    ripgrep
    fd
    bat
    teavpn2
    i3status
  ];
}
