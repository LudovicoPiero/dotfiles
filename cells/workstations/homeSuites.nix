{
  inputs,
  cell,
}: let
  inherit (cell) homeProfiles;
in
  with homeProfiles; rec {
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
      mako
      xdg-portal
    ];

    editor = [nvim];

    graphical =
      base
      ++ commonGraphic
      ++ editor
      ++ [
        theme

        # Windows Manager / Compositor
        hyprland
        fuzzel
        kitty
        alacritty
        waybar

        # Etc
        discord
        mako
        spotify
        gammastep
      ];

    airi = graphical;
  }
