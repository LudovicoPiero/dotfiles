# Add your reusable NixOS modules to this directory, on their own file (https://nixos.wiki/wiki/Module).
# These should be stuff you would like to share with others, not your personal configurations.
{
  # List your module files here
  webcord = import ./apps/webcord.nix;
  file-manager = import ./apps/file-manager.nix;

  # System
  gnome = import ./windowmanager/gnome.nix;
  hyprland = import ./windowmanager/hyprland.nix;
  bootloader = import ./system/bootloader.nix;
  user = import ./system/user.nix;
  doas = import ./system/doas.nix;
  fonts = import ./system/fonts.nix;
}
