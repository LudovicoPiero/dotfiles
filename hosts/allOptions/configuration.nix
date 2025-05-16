# NOTE:
# This is a configuration that will enable all options inside myOptions.nix.
# It is only used for caching purpose only!
{ lib, ... }:
{
  imports = [ ./myOptions.nix ];

  networking.hostName = "allOptions"; # Define your hostname.
  networking.networkmanager.enable = true; # Easiest to use and most distros use this by default.
  boot.loader.grub.device = "/dev/disk/by-id/wwn-0x500001234567890a";
  fileSystems = {
    "/".device = "/dev/hda1";
  };
  system.stateVersion = "24.11";
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
