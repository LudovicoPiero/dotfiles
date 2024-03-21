{ inputs, cell }:
let
  inherit (inputs) nixpkgs;
in
{
  virtualisation = {
    libvirtd = {
      enable = true;
      qemu = {
        verbatimConfig = ''
          nvram = [ "${nixpkgs.OVMF}/FV/OVMF.fd:${nixpkgs.OVMF}/FV/OVMF_VARS.fd" ]
        '';
      };
    };
    spiceUSBRedirection.enable = true;
  };

  environment = {
    systemPackages = with nixpkgs; [
      virt-manager
      virt-viewer
      qemu
      OVMF
      gvfs # Used for shared folders between Linux and Windows
    ];
  };
}
