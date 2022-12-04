{pkgs, ...}: {
  # Bootloader.
  boot = {
      kernelPackages = pkgs.linuxPackages_xanmod;
    supportedFilesystems = ["ntfs"];
    loader = {
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot/efi";
      };
      # systemd-boot.enable = true;
      grub = {
        enable = true;
        efiSupport = true;
        version = 2;
        device = "nodev";
        useOSProber = true;
      };
    };
  };
  kernel.sysctl = {
      "vm.swappiness" = 10;
  };

    console = {
    font = "Lat2-Terminus16";
    keyMap = "us";

    colors =
      let colorscheme = inputs.nix-colors.colorSchemes.material-darker;
      in
      with colorscheme.colors; [
        base01
        base08
        base0B
        base0A
        base0D
        base0E
        base0C
        base06
        base02
        base08
        base0B
        base0A
        base0D
        base0E
        base0C
        base07
      ];
  };
}
