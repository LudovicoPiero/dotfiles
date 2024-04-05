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

      # Etc
      discord
      spotify
      gammastep
    ];

    editor = [nvim];

    graphical =
      base
      ++ commonGraphic
      ++ editor
      ++ [
        theme

        # Windows Manager / Compositor
        # hyprland
        # waybar
        sway
        i3status-rust
        fuzzel
        foot
        tmux
      ];

    airi = graphical;
  }
