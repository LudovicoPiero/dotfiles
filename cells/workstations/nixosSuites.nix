{ inputs, cell }:
let
  inherit (cell) nixosProfiles;
in
with nixosProfiles;
rec {
  base = [
    common
    users
    security
  ];

  graphical = [
    greetd
    fonts
    keyring
    fcitx5
    gamemode
    steam
    pipewire
    thunar
    xdg-portal
  ];

  sforza = base ++ graphical;
}
