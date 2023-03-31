{
  pkgs,
  config,
  lib,
  ...
}: {
  virtualisation = {
    libvirtd = {
      enable = true;
      # spiceUSBRedirection.enable = true; # USB Passthrough
    };
  };

  environment.systemPackages = with pkgs; [
    virt-manager
    virt-viewer
    qemu
    OVMF
    gvfs
  ];

  services = {
    # Enable file sharing between OS
    gvfs.enable = true;
  };
}
