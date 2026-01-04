{ inputs, withSystem }:
final: prev: {
  # Usage: lib.strip "#1a1b26" -> "1a1b26"
  strip = color: prev.substring 1 6 color;

  # Usage: lib.mkHost ./hosts/kofun "kofun"
  mkHost = import ./mkHost.nix {
    inherit inputs withSystem;
    lib = final;
  };
}
