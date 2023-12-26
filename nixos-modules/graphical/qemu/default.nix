{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.mine.qemu;
  inherit (lib) mkIf mkOption types;
in
{
  options.mine.qemu = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Enable Qemu and Virt-Manager.
      '';
    };
  };

  config = mkIf cfg.enable {
    virtualisation = {
      libvirtd = {
        enable = true;
        onBoot = "ignore";
        onShutdown = "shutdown";
        qemu = {
          verbatimConfig = ''
            nvram = [ "${pkgs.OVMF}/FV/OVMF.fd:${pkgs.OVMF}/FV/OVMF_VARS.fd" ]
          '';
        };
      };
      spiceUSBRedirection.enable = true;
    };

    environment = {
      systemPackages = with pkgs; [
        virt-manager
        virt-viewer
        qemu
        OVMF
        gvfs # Used for shared folders between Linux and Windows
      ];
    };
  };
}
