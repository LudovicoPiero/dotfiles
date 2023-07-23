{...}: {
  security = {
    pam.services.greetd.gnupg.enable = true;
    pam.services.greetd.enableGnomeKeyring = true;
    pam.services.swaylock.text = "auth include login";
  };

  programs.dconf.enable = true;
}
