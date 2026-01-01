{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib)
    mkOption
    types
    mkIf
    mkEnableOption
    ;
  inherit (config.mine) vars;

  cfg = config.mine.gpg;
  guiCfg = vars.withGui;
in
{
  options.mine.gpg = {
    enable = mkEnableOption "GPG configuration";

    cacheTTL = mkOption {
      type = types.int;
      default = 3600; # 1 Hour
      description = "GPG Agent Cache TTL";
    };
  };

  config = mkIf cfg.enable {
    programs = {
      gnupg.agent = {
        enable = true;
        enableSSHSupport = true;
        pinentryPackage = if guiCfg then pkgs.pinentry-gnome3 else pkgs.pinentry-curses;
      };

      fish.interactiveShellInit = ''
        set -gx GPG_TTY (tty)
      '';
    };

    # Necessary for some GUI pinentry prompts to work correctly
    services.dbus.packages = [ pkgs.gcr ];

    environment.sessionVariables = {
      GNUPGHOME = "${vars.homeDirectory}/.config/gnupg";
    };

    hj = {
      xdg.config.files."gnupg/gpg-agent.conf".text = ''
        default-cache-ttl ${toString cfg.cacheTTL}
        grab
        enable-ssh-support
        allow-emacs-pinentry
        allow-loopback-pinentry
        allow-preset-passphrase
        pinentry-program ${
          if guiCfg then
            "${pkgs.pinentry-gnome3}/bin/pinentry"
          else
            "${pkgs.pinentry-curses}/bin/pinentry"
        }
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
