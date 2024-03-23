{
  inputs,
  cell,
}: let
  inherit (cell) nixosProfiles;
in
  with nixosProfiles; rec {
    base = [
      common
      users
      security
    ];

    graphical = [
      greetd
      fonts
      keyring
      gamemode
      steam
      pipewire
      thunar
    ];

    sforza = base ++ graphical;
  }
