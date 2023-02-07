{suites, ...}: {
  ### root password is empty by default ###
  imports =
    [./hardware-configuration.nix]
    ++ suites.base
    # ++ suites.graphical #TODO: add graphical suite
    ;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efiSysMountPoint = "/boot/efi";

  networking.networkmanager.enable = true;
}
