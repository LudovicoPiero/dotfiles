_: {
  flake.nixosModules.sforza =
    { ... }:
    {
      imports = [
        ./nixos
        ./nixos/core/dnscrypt
        ./nixos/core/stubby
        ./nixos/core/security
        ./nixos/core/users
        ./nixos/core/fonts
        ./nixos/core/gnome

        ./nixos/graphical/games
        ./nixos/graphical/greetd
        ./nixos/graphical/thunar
        ./nixos/graphical/qemu
      ];
    };

  flake.homeModules.ludovico =
    { ... }:
    {
      imports = [
        # ./home/core
        # ./home/graphical
        # ./home/editor
        ./home/browser
        # ./home/windowManager/hyprland
        # ./home/windowManager/river
        # ./home/windowManager/sway

        # inputs.nur.hmModules.nur
        # inputs.nix-colors.homeManagerModules.default
        # inputs.spicetify-nix.homeManagerModules.default
      ];
    };
}
