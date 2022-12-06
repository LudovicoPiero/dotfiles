# Add your reusable NixOS modules to this directory, on their own file (https://nixos.wiki/wiki/Module).
# These should be stuff you would like to share with others, not your personal configurations.
{
  # Apps
  thunar = import ./apps/thunar.nix;

  # System
  gnome = import ./windowmanager/gnome.nix;

  # System
  bootloader = import ./system/bootloader.nix;
  greetd = import ./system/greetd.nix;
  desktop = import ./system/desktop.nix;
  user = import ./system/user.nix;
  doas = import ./system/doas.nix;
  fonts = import ./system/fonts.nix;
}
