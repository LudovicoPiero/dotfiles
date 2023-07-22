{config, ...}: {
  programs.gpg = {
    enable = true;
    homedir = "${config.xdg.configHome}/gnupg";
  };

  # Fix pass
  services.gpg-agent = {
    enable = true;
    pinentryFlavor = "gnome3";
    extraConfig = ''
      allow-emacs-pinentry
      allow-loopback-pinentry
      allow-preset-passphrase
    '';
  };
}
