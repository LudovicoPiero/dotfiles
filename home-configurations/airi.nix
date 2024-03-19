{
  pkgs,
  username,
  osConfig,
  ...
}: {
  home = {
    inherit username;
    homeDirectory = osConfig.users.users.airi.home;

    stateVersion = "23.11";
  };

  home.packages = with pkgs; [
    alejandra
    fluffychat
    nil
  ];

  mine = {
    # Editor
    emacs.enable = false;
    nvim.enable = true;

    # WM
    hyprland.enable = false;
    sway = {
      enable = true;
      useSwayFX = true;
    };

    # Graphical
    chromium.enable = true;
    discord.enable = true;
    direnv.enable = true;
    fish.enable = true;
    firefox.enable = true;
    fuzzel.enable = true;
    gammastep.enable = true;
    git.enable = true;
    gpg.enable = true;
    kitty.enable = true;
    lazygit.enable = true;
    mako.enable = true;
    pass.enable = true;
    ssh.enable = true;
    waybar.enable = true;
    wezterm.enable = true;
  };
}
