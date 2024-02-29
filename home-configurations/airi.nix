{
  inputs,
  pkgs,
  username,
  osConfig,
  ...
}:
{
  home = {
    inherit username;
    homeDirectory = osConfig.users.users.airi.home;

    stateVersion = "23.11";
  };

  home.packages = with pkgs; [
    nil
    inputs.chaotic.packages.${pkgs.system}.nixfmt_rfc166
  ];

  mine = {
    # Editor
    nvim.enable = true;
    emacs.enable = true;

    # WM
    hyprland.enable = true;
    niri.enable = true;
    sway = {
      enable = true;
      useSwayFX = true;
    };

    # Graphical
    chromium.enable = true;
    foot.enable = true;
    firefox.enable = true;
    discord.enable = true;
    direnv.enable = true;
    fuzzel.enable = true;
    wezterm.enable = true;
    mako.enable = true;
    ssh.enable = true;
    gammastep.enable = true;
    git.enable = true;
    gpg.enable = true;
    waybar.enable = true;
    fish.enable = true;
    pass.enable = true;
    lazygit.enable = true;
  };
}
