{
  programs.gpg = {
    enable = true;
  };

  # Fix pass
  services.gpg-agent = {
    enable = true;
    pinentryFlavor = "gnome3";
  };
}
