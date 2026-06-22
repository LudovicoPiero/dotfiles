{ pkgs, config, ... }: {
  # Necessary for some GUI pinentry prompts to work correctly
  services.dbus.packages = [ pkgs.gcr ];

  hm = {
    # Example configuration snippet
    home.file.".config/gnupg/gpg-agent.conf".text = ''
      pinentry-program ${pkgs.pinentry-gnome3}/bin/pinentry
      default-cache-ttl 3600
      grab
      enable-ssh-support
      allow-emacs-pinentry
      allow-loopback-pinentry
      allow-preset-passphrase
    '';

    programs.gpg = {
      enable = true;
      homedir = "${config.hm.xdg.configHome}/gnupg";

      settings = {
        s2k-cipher-algo = "AES256";
        s2k-digest-algo = "SHA512";
        cert-digest-algo = "SHA512";
        charset = "utf-8";
        keyid-format = "0xlong";
      };
    };
  };
}
