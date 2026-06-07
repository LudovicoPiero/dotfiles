{
  mine = {
    # WM / Compositor
    i3.enable = false;
    niri.enable = true;
    hyprland.enable = false;
    mango.enable = false;

    # Apps
    alacritty.enable = false;
    ghostty.enable = true;
    fish.enable = true;
    firefox.enable = true;
    zen-browser.enable = true;
    keyring.enable = true;
    git.enable = true;
    inputMethod = {
      enable = true;
      type = "fcitx5";

    };
    fonts.enable = true;
    gtk.enable = true;
    gpg.enable = true;
    mako.enable = true;
    rofi.enable = true;
    tmux.enable = true;
    portal.enable = true;
    qemu.enable = false;

    games = {
      nix-ld.enable = true;
      steam.enable = true;
      lutris.enable = true;
      gamemode.enable = true;
    };

    music = {
      mpd.enable = true;
      rmpc.enable = true;
    };

    # Vars
    vars = {
      email = "lewdovico@gnuweeb.org";
      signingKey = "3911DD276CFE779C";
      withGui = true;
      isALaptop = true;
    };
  };
}
