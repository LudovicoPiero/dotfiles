{ inputs, cell }:
let
  inherit (cell) homeProfiles;
in
with homeProfiles;
rec {
  base = [
    common
    direnv
    gpg
    git
    ssh
    fish
  ];

  commonGraphic = [
    firefox
    floorp
    mako

    # Etc
    discord
    spotify
    gammastep
  ];

  editor = [
    # emacs
    nvim
  ];

  graphical =
    base
    ++ commonGraphic
    ++ editor
    ++ [
      theme

      # Windows Manager / Compositor
      hyprland
      sway

      # Apps
      waybar
      i3status-rust
      i3status
      fuzzel
      foot
      kitty
      wezterm
      tmux
      lsd
    ];

  airi = graphical;
}
