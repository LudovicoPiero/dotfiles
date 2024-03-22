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

  graphical = base ++ [
    theme

    # Windows Manager / Compositor
    hyprland
    fuzzel
    kitty
    waybar
    wezterm

    # Browser
    firefox

    # Etc
    discord
    mako
    spotify
    gammastep
    xdg-portal
  ];

  airi = graphical;
}
