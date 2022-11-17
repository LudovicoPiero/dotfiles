# Add your reusable NixOS modules to this directory, on their own file (https://nixos.wiki/wiki/Module).
# These should be stuff you would like to share with others, not your personal configurations.

{
  # List your module files here
  fonts = import ./fonts.nix;
  user = import ./user.nix;
  doas = import ./doas.nix;
  bootloader = import ./bootloader.nix;
  file-manager = import ./file-manager.nix;
}
