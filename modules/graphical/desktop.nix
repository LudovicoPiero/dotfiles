{
  inputs,
  pkgs,
  ...
}: {
  security = {
    pam.services.greetd.gnupg.enable = true;
    pam.services.greetd.enableGnomeKeyring = true;
    pam.services.sddm.gnupg.enable = true;
    pam.services.sddm.enableGnomeKeyring = true;
    pam.services.swaylock.text = "auth include login";
  };

  services.xserver.displayManager.sessionPackages = [inputs.hyprland.packages.${pkgs.system}.default];

  programs.dconf.enable = true;
}
