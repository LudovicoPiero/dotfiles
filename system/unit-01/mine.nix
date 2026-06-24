{
  mine = {
    # WM / Compositor
    sway.enable = true;

    # Apps
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
    nvim.enable = true;
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
