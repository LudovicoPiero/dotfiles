{
  inputs,
  pkgs,
  username,
  ...
}:
{
  home = {
    inherit username;
    homeDirectory = "/home/airi";

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
    sway = {
      enable = true;
      useSwayFX = true;
    };

    # Graphical
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
  };
}
