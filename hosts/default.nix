{ withSystem, inputs, ... }:
let
  mkHost = import ../lib/mkHost.nix { inherit withSystem inputs; };
in
{
  flake.nixosConfigurations = {
    sforza = mkHost "sforza" ./sforza/configuration.nix "x86_64-linux";
  };
}
