{
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (lib) mkOption types mkIf;
  cfg = config.mine.qemu;
in
{
  options.mine.qemu = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable qemu configuration.";
    };
  };

  config = mkIf cfg.enable {
    users.users.${config.mine.vars.username} = {
      extraGroups = [ "libvirtd" ];
    };

    environment.systemPackages = with pkgs; [
      qemu
      qemu_kvm
      libvirt
      virt-manager
      virt-viewer
      spice-gtk
      OVMF
      swtpm
    ];

    virtualisation = {
      # Enable TPM emulation (optional)
      # install pkgs.swtpm system-wide for use in virt-manager (optional)
      libvirtd.qemu = {
        swtpm.enable = true;
      };

      libvirtd.enable = true;
      # Enable USB redirection (optional)
      spiceUSBRedirection.enable = true;
    };
  };
}
