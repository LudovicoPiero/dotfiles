{
  lib,
  pkgs,
  config,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    mkOption
    types
    mkIf
    ;

  cfg = config.mine.gpg;
  guiCfg = config.vars.withGui;
in
{
  options.mine.gpg = {
    enable = mkEnableOption "gpg";

    cacheTTL = mkOption {
      type = types.int;
      default = 3600; # 1 Hour
    };
  };

  config = mkIf cfg.enable {
    services.dbus.packages = [ pkgs.gcr ];
    environment.sessionVariables = {
      GNUPGHOME = "/home/${config.vars.username}/.config/gnupg";
    };

    programs.gnupg = {
      agent = {
        enable = true;
        enableSSHSupport = true;
        pinentryPackage = if guiCfg then pkgs.pinentry-gnome3 else pkgs.pinentry-curses;
      };
    };

    hj = {
      xdg.config.files."gnupg/gpg-agent.conf".text = ''
        default-cache-ttl ${toString cfg.cacheTTL}
        grab
        enable-ssh-support
        allow-emacs-pinentry
        allow-loopback-pinentry
        allow-preset-passphrase
      '';

      xdg.config.files."gnupg/gpg.conf".text = ''
        cert-digest-algo SHA512
        charset utf-8
        default-preference-list SHA512 SHA384 SHA256 AES256 AES192 AES ZLIB BZIP2 ZIP Uncompressed
        fixed-list-mode
        keyid-format 0xlong
        list-options show-uid-validity
        no-comments
        no-emit-version
        no-symkey-cache
        personal-cipher-preferences AES256 AES192 AES
        personal-compress-preferences ZLIB BZIP2 ZIP Uncompressed
        personal-digest-preferences SHA512 SHA384 SHA256
        require-cross-certification
        s2k-cipher-algo AES256
        s2k-digest-algo SHA512
        use-agent
        verify-options show-uid-validity
        with-fingerprint
      '';
    };
  };
}
