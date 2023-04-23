{
  config,
  nixpkgs,
  inputs,
  overlays,
  ...
}:
nixpkgs.lib.nixosSystem rec {
  system = "x86_64-linux";
  modules = [
    inputs.impermanence.nixosModules.impermanence
    {
      nix = import ../../nix-settings.nix {
        inherit inputs system nixpkgs;
        max-jobs = 4;
      };

      nixpkgs = {inherit config overlays;};
      networking.hostName = "sforza";

      /*
      NOTE: Do not change this
      unless you know what you're doing
      */
      system.stateVersion = "22.11";
    }

    ./configuration.nix
  ];

  specialArgs = {inherit inputs system;};
}
