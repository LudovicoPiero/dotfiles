{
  lib,
  pkgs,
  config,
  inputs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf mkMerge;

  cfg = config.myOptions.firefox;
in
{
  imports = [
    ./preferences.nix
    ./policies.nix
  ];

  options.myOptions.firefox = {
    enable = mkEnableOption "firefox browser" // {
      default = config.vars.withGui;
    };

    withGnomeTheme = mkEnableOption "Leptop Theme" // {
      default = false;
      description = ''
        Use Gnome Theme for Firefox.
        https://github.com/rafaelmardojai/firefox-gnome-theme
      '';
    };
  };

  config = mkIf cfg.enable {
    programs.firefox = {
      enable = true;

      #NOTE:
      # Use firefox-esr because some policies only works in ESR
      package = pkgs.firefox-esr;
    };

    hj.files =
      let
        inherit (inputs.self.packages.${pkgs.stdenv.hostPlatform.system}) firefox-gnome-theme;

        profilePath = ".mozilla/firefox/${config.vars.username}";
      in
      mkMerge [
        {
          ".mozilla/firefox/profiles.ini".text = ''
            [General]
            StartWithLastProfile=1
            Version=2

            [Profile0]
            Name=${config.vars.username}
            IsRelative=1
            Path=${config.vars.username}
            Default=1
          '';
        }
        (mkIf cfg.withGnomeTheme {
          "${profilePath}/chrome/userChrome.css".text = ''
            @import "${firefox-gnome-theme}/userChrome.css";
          '';

          "${profilePath}/chrome/userContent.css".text = ''
            @import "${firefox-gnome-theme}/userContent.css";
          '';
        })
      ];
  };
}
