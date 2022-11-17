{ pkgs, ... }:
{
  # Bootloader.
  boot = {
    kernelPackages = pkgs.linuxPackages_zen;
    supportedFilesystems = [ "ntfs" ];
    loader = {
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot/efi";
      };
      grub = {
        enable = true;
        efiSupport = true;
        version = 2;
        device = "nodev";
        useOSProber = true;
      };
    };
  };
}
